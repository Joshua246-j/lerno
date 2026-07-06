export interface Course {
  id: string;
  title: string;
  description: string;
  svgAsset: string;
  color: string;
  progress: number;
  totalLessons: number;
  completedLessons: number;
}

export interface Game {
  id: string;
  title: string;
  category: string;
  svgAsset: string;
  color: string;
}

export interface Mission {
  id: string;
  title: string;
  progressText: string;
  progress: number;
  rewardXp: number;
  rewardCoins: number;
  isCompleted?: boolean;
}

export interface Activity {
  title: string;
  iconName: string;
  color: string;
  route: string;
}

export interface Recommendation {
  id: string;
  title: string;
  subtitle: string;
  svgAsset: string;
  stars: number;
}

export interface Banner {
  title: string;
  subtitle: string;
  actionText: string;
  route: string;
  bgColor: string;
  svgAsset: string;
}

export interface UserProfile {
  id: string;
  name: string;
  age: number;
  phoneNumber: string;
  avatarId: string;
  grade: string;
  awards: number;
  xp: number;
  coins: number;
}
