import { create } from "zustand";
import { UserProfile } from "@lerno/types";
import { MockAuthRepository } from "../repository/MockAuthRepository";

const authRepo = new MockAuthRepository();

interface AuthState {
  user: UserProfile | null;
  token: string | null;
  isLoading: boolean;
  login: (phoneNumber: string) => Promise<void>;
  register: (data: { name: string; phoneNumber: string; age: number; avatarId: string }) => Promise<void>;
  logout: () => Promise<void>;
}

export const useAuth = create<AuthState>((set) => ({
  user: null,
  token: null,
  isLoading: false,
  login: async (phoneNumber: string) => {
    set({ isLoading: true });
    try {
      const { user, token } = await authRepo.login(phoneNumber);
      set({ user, token, isLoading: false });
    } catch (error) {
      set({ isLoading: false });
      throw error;
    }
  },
  register: async (data) => {
    set({ isLoading: true });
    try {
      const { user, token } = await authRepo.register(data);
      set({ user, token, isLoading: false });
    } catch (error) {
      set({ isLoading: false });
      throw error;
    }
  },
  logout: async () => {
    set({ isLoading: true });
    await authRepo.logout();
    set({ user: null, token: null, isLoading: false });
  },
}));
