import { AuthRepository } from "./AuthRepository";
import { UserProfile } from "@lerno/types";

// Mock data acting as a database
let currentUser: UserProfile | null = null;

export class MockAuthRepository implements AuthRepository {
  async login(phoneNumber: string): Promise<{ token: string; user: UserProfile }> {
    await new Promise(resolve => setTimeout(resolve, 500)); // simulate latency
    
    // In a real mock, we'd check against a list. For now, just return a fake user if they "log in".
    const user: UserProfile = {
      id: "u1",
      name: "AstroKid",
      age: 10,
      phoneNumber,
      avatarId: "dragon",
      grade: "Grade 2",
      awards: 5,
      xp: 150,
      coins: 20
    };
    currentUser = user;
    
    return { token: "mock_jwt_token_123", user };
  }

  async register(data: { name: string; phoneNumber: string; age: number; avatarId: string; }): Promise<{ token: string; user: UserProfile }> {
    await new Promise(resolve => setTimeout(resolve, 800));
    
    const user: UserProfile = {
      id: `u_${Date.now()}`,
      name: data.name,
      age: data.age,
      phoneNumber: data.phoneNumber,
      avatarId: data.avatarId,
      grade: "Grade 1",
      awards: 0,
      xp: 0,
      coins: 0
    };
    currentUser = user;
    
    return { token: "mock_jwt_token_456", user };
  }

  async getCurrentUser(): Promise<UserProfile> {
    await new Promise(resolve => setTimeout(resolve, 300));
    if (!currentUser) throw new Error("Not authenticated");
    return currentUser;
  }

  async logout(): Promise<void> {
    await new Promise(resolve => setTimeout(resolve, 300));
    currentUser = null;
  }
}
