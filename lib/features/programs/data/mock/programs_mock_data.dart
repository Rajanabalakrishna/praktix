import 'package:praktix/features/programs/domain/entities/program_entity.dart';

class ProgramsMockData {
  static const List<ProgramEntity> programs = [
    ProgramEntity(
      id: 'p1',
      title: 'AI Leadership Masterclass',
      description:
      'An exclusive intensive for C-suite & senior directors to navigate strategic AI integration across enterprise operations.',
      instructorName: 'Dr. Meera Kapoor',
      instructorTitle: 'Chief AI Officer · Ex-Google',
      thumbnailUrl:
      'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=800&q=80',
      type: ProgramType.masterclass,
      category: ProgramCategory.leadership,
      duration: 'Self-paced',
      hasCertificate: true,
      isPaid: true,
      rating: 4.9,
      studentsEnrolled: 3200,
      isFeatured: true,
    ),
    ProgramEntity(
      id: 'p2',
      title: 'AI for Managers',
      description:
      'Operationalize AI within your team. Learn to identify use cases, manage projects, and measure ROI effectively.',
      instructorName: 'Rajan Mehta',
      instructorTitle: 'VP Product · Razorpay',
      thumbnailUrl:
      'https://images.unsplash.com/photo-1553877522-43269d4ea984?w=800&q=80',
      type: ProgramType.course,
      category: ProgramCategory.ai,
      duration: '4 weeks',
      hasCertificate: true,
      isPaid: false,
      rating: 4.7,
      studentsEnrolled: 8900,
    ),
    ProgramEntity(
      id: 'p3',
      title: 'AI for Healthcare',
      description:
      'Predictive diagnostics, workflow automation, and ethical data handling in clinical settings.',
      instructorName: 'Dr. Priya Nair',
      instructorTitle: 'Head of Health AI · Apollo',
      thumbnailUrl:
      'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&q=80',
      type: ProgramType.course,
      category: ProgramCategory.ai,
      duration: '6 weeks',
      hasCertificate: true,
      isPaid: false,
      rating: 4.8,
      studentsEnrolled: 5400,
    ),
    ProgramEntity(
      id: 'p4',
      title: 'AI for Developers',
      description:
      'Deep dive into LLM integration, fine-tuning methodologies, and building agentic systems end-to-end.',
      instructorName: 'Arjun Reddy',
      instructorTitle: 'Staff Engineer · Microsoft',
      thumbnailUrl:
      'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=800&q=80',
      type: ProgramType.bootcamp,
      category: ProgramCategory.mobile,
      duration: '8 weeks',
      hasCertificate: true,
      isPaid: true,
      rating: 4.9,
      studentsEnrolled: 12000,
    ),
    ProgramEntity(
      id: 'p5',
      title: 'Cybersecurity Internship',
      description:
      'Hands-on experience securing enterprise AI infrastructure alongside top-tier security analysts.',
      instructorName: 'Kiran Sharma',
      instructorTitle: 'CISO · Infosys Security Labs',
      thumbnailUrl:
      'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800&q=80',
      type: ProgramType.internship,
      category: ProgramCategory.cybersecurity,
      duration: '3 months',
      hasCertificate: true,
      isPaid: true,
      rating: 4.6,
      studentsEnrolled: 420,
    ),
    ProgramEntity(
      id: 'p6',
      title: 'Data Science Bootcamp',
      description:
      'From raw data to production ML pipelines. Pandas, scikit-learn, and MLOps fundamentals included.',
      instructorName: 'Sneha Iyer',
      instructorTitle: 'Lead Data Scientist · Flipkart',
      thumbnailUrl:
      'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&q=80',
      type: ProgramType.bootcamp,
      category: ProgramCategory.data,
      duration: '10 weeks',
      hasCertificate: true,
      isPaid: false,
      rating: 4.8,
      studentsEnrolled: 6700,
    ),
  ];
}