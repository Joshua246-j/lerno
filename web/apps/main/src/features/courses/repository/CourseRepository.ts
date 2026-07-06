import { Course } from "@lerno/types";

export interface CourseRepository {
  getCourses(): Promise<Course[]>;
  getCourseById(id: string): Promise<Course>;
}
