import { UserProfile } from "@lerno/types";

export interface AuthRepository {
  login(phoneNumber: string): Promise<{ token: string, user: UserProfile }>;
  register(data: { name: string, phoneNumber: string, age: number, avatarId: string }): Promise<{ token: string, user: UserProfile }>;
  getCurrentUser(): Promise<UserProfile>;
  logout(): Promise<void>;
}
