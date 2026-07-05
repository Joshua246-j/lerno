> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# WebSocket Architecture

## ⚡ Purpose

Real-time features are a cornerstone of the Lerno gamified experience. While standard REST APIs handle standard data fetches, **WebSockets** are required for low-latency, bidirectional communication.

## 🎯 Use Cases

1. **1v1 Quiz Battles**: Live matchmaking, real-time question broadcasting, live opponent score updates, and match conclusion.
2. **Live Chat**: Real-time peer-to-peer messaging between friends.
3. **In-App Notifications**: Instant alerts when a friend comes online or sends a challenge.

## 🏗 Architecture

FastAPI provides native, highly performant WebSocket support. However, because our backend may eventually scale to multiple container instances, WebSocket connections must be synchronized across workers using **Redis Pub/Sub**.

### 1. Connection Manager

A centralized Connection Manager keeps track of active WebSocket connections.

```python
from fastapi import WebSocket
from typing import Dict, List

class ConnectionManager:
    def __init__(self):
        # Maps user_id to a list of active WebSocket connections
        self.active_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, user_id: str, websocket: WebSocket):
        await websocket.accept()
        if user_id not in self.active_connections:
            self.active_connections[user_id] = []
        self.active_connections[user_id].append(websocket)

    def disconnect(self, user_id: str, websocket: WebSocket):
        self.active_connections[user_id].remove(websocket)

    async def send_personal_message(self, message: dict, user_id: str):
        if user_id in self.active_connections:
            for connection in self.active_connections[user_id]:
                await connection.send_json(message)
                
manager = ConnectionManager()
```

### 2. FastAPI Endpoint

```python
from fastapi import APIRouter, WebSocket, WebSocketDisconnect

router = APIRouter()

@router.websocket("/ws/chat/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    await manager.connect(user_id, websocket)
    try:
        while True:
            data = await websocket.receive_json()
            # Process incoming message, save to DB, and broadcast to recipient
            recipient_id = data.get("to")
            await manager.send_personal_message(data, recipient_id)
    except WebSocketDisconnect:
        manager.disconnect(user_id, websocket)
```

## 🔒 Security

WebSockets cannot rely on traditional HTTP headers for authentication cleanly in all clients. The Flutter app must either pass the JWT token as a query parameter (`/ws?token=abc`) or send an initial authentication JSON message immediately upon connecting before the server accepts the socket.
