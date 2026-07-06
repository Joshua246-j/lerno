import { useQuery } from "@tanstack/react-query";
import { MockCourseRepository } from "../repository/MockCourseRepository";

const courseRepo = new MockCourseRepository();

export function useCourses() {
  return useQuery({
    queryKey: ["courses"],
    queryFn: () => courseRepo.getCourses(),
  });
}

export function useCourse(id: string) {
  return useQuery({
    queryKey: ["courses", id],
    queryFn: () => courseRepo.getCourseById(id),
  });
}
