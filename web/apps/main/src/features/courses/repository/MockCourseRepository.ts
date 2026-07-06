import { CourseRepository } from "./CourseRepository";
import { Course } from "@lerno/types";

const MOCK_COURSES: Course[] = [
  {
    id: 'math_101',
    title: 'Basic Addition',
    description: 'Learn to add numbers up to 20.',
    svgAsset: 'assets/svg/courses/maths.svg',
    color: 'bg-[#3B82F6]',
    progress: 0.6,
    totalLessons: 10,
    completedLessons: 6,
  },
  {
    id: 'sci_101',
    title: 'Solar System',
    description: 'Explore the planets in our solar system.',
    svgAsset: 'assets/svg/courses/science.svg',
    color: 'bg-[#10B981]',
    progress: 0.2,
    totalLessons: 5,
    completedLessons: 1,
  },
  {
    id: 'eng_101',
    title: 'Alphabet Fun',
    description: 'Master your ABCs with fun games.',
    svgAsset: 'assets/svg/courses/english.svg',
    color: 'bg-[#8B5CF6]',
    progress: 1.0,
    totalLessons: 8,
    completedLessons: 8,
  },
];

export class MockCourseRepository implements CourseRepository {
  async getCourses(): Promise<Course[]> {
    await new Promise(resolve => setTimeout(resolve, 500));
    return MOCK_COURSES;
  }

  async getCourseById(id: string): Promise<Course> {
    await new Promise(resolve => setTimeout(resolve, 300));
    const course = MOCK_COURSES.find(c => c.id === id);
    if (!course) throw new Error("Course not found");
    return course;
  }
}
