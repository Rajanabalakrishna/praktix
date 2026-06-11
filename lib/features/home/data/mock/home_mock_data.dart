import 'package:praktix/features/home/domain/entities/expert_entity.dart';
import 'package:praktix/features/home/domain/entities/job_entity.dart';
import 'package:praktix/features/home/domain/entities/program_entity.dart';
import 'package:praktix/features/home/domain/entities/video_entity.dart';
import 'package:praktix/features/home/domain/entities/workshop_entity.dart';

// Real free-to-use YouTube embeddable study videos
const _yt1 = 'https://www.youtube.com/embed/aircAruvnKk'; // 3Blue1Brown Neural Networks
const _yt2 = 'https://www.youtube.com/embed/ukzFI9rgwfU'; // ML full course
const _yt3 = 'https://www.youtube.com/embed/7eh4d6sabA0'; // Prompt Engineering
const _yt4 = 'https://www.youtube.com/embed/GwIo3gDZCVQ'; // LLM intro
const _yt5 = 'https://www.youtube.com/embed/PaCmpygFfXo'; // Deep Learning

// Picsum stable seeds for thumbnails / avatars
String _thumb(int seed) =>
    'https://picsum.photos/seed/vid$seed/400/220';
String _avatar(int seed) =>
    'https://picsum.photos/seed/exp$seed/100/100';
String _prog(int seed) =>
    'https://picsum.photos/seed/prog$seed/200/140';

final mockExperts = <ExpertEntity>[
  ExpertEntity(
    id: 'e1',
    name: 'Dr. Sarah Jenkins',
    title: 'AI Strategy Consultant',
    imageUrl: _avatar(1),
    tags: ['Generative AI', 'Leadership'],
    isVerified: true,
    rating: 4.9,
    sessionRate: '\$120/hr',
  ),
  ExpertEntity(
    id: 'e2',
    name: 'Marcus Chen',
    title: 'VP of Machine Learning',
    imageUrl: _avatar(2),
    tags: ['LLMs', 'Architecture'],
    isVerified: true,
    rating: 4.8,
    sessionRate: '\$150/hr',
  ),
  ExpertEntity(
    id: 'e3',
    name: 'Elena Rodriguez',
    title: 'Applied Prompt Engineer',
    imageUrl: _avatar(3),
    tags: ['NLP', 'UX Research'],
    isVerified: false,
    rating: 4.7,
    sessionRate: '\$90/hr',
  ),
  ExpertEntity(
    id: 'e4',
    name: 'Priya Sharma',
    title: 'Data Science Lead',
    imageUrl: _avatar(4),
    tags: ['Python', 'Analytics'],
    isVerified: true,
    rating: 4.9,
    sessionRate: '\$110/hr',
  ),
  ExpertEntity(
    id: 'e5',
    name: 'James Okafor',
    title: 'Cybersecurity Architect',
    imageUrl: _avatar(5),
    tags: ['Security', 'Cloud'],
    isVerified: true,
    rating: 4.8,
    sessionRate: '\$130/hr',
  ),
];

final mockPrograms = <ProgramEntity>[
  ProgramEntity(
    id: 'p1',
    title: 'AI for Managers',
    description: 'Strategic AI adoption across enterprise teams.',
    duration: '6 Weeks',
    hasCertificate: true,
    iconName: 'business_center',
    accentHex: '#4b41e1',
  ),
  ProgramEntity(
    id: 'p2',
    title: 'AI for Healthcare',
    description: 'Clinical AI diagnostics and patient data systems.',
    duration: '8 Weeks',
    hasCertificate: true,
    iconName: 'health_and_safety',
    accentHex: '#0EA5E9',
  ),
  ProgramEntity(
    id: 'p3',
    title: 'AI for Developers',
    description: 'Build and deploy production LLM-powered apps.',
    duration: '10 Weeks',
    hasCertificate: true,
    iconName: 'terminal',
    accentHex: '#059669',
  ),
  ProgramEntity(
    id: 'p4',
    title: 'AI Leadership',
    description: 'Lead AI transformation in your organization.',
    duration: '4 Weeks',
    hasCertificate: true,
    iconName: 'military_tech',
    accentHex: '#B45309',
  ),
  ProgramEntity(
    id: 'p5',
    title: 'Cybersecurity Internship',
    description: 'Hands-on threat analysis and secure systems design.',
    duration: '12 Weeks',
    hasCertificate: true,
    iconName: 'security',
    accentHex: '#DC2626',
  ),
];

final mockVideos = <VideoEntity>[
  VideoEntity(
    id: 'v1',
    title: 'Neural Networks Explained Visually',
    expertName: 'Dr. Sarah Jenkins',
    expertImageUrl: _avatar(1),
    thumbnailUrl: _thumb(1),
    videoUrl: _yt1,
    duration: '3:47',
    isPremium: false,
    likes: 4820,
    topic: 'Deep Learning',
  ),
  VideoEntity(
    id: 'v2',
    title: 'Machine Learning Full Crash Course',
    expertName: 'Marcus Chen',
    expertImageUrl: _avatar(2),
    thumbnailUrl: _thumb(2),
    videoUrl: _yt2,
    duration: '8:12',
    isPremium: true,
    likes: 3150,
    topic: 'ML Fundamentals',
  ),
  VideoEntity(
    id: 'v3',
    title: 'Master Prompt Engineering',
    expertName: 'Elena Rodriguez',
    expertImageUrl: _avatar(3),
    thumbnailUrl: _thumb(3),
    videoUrl: _yt3,
    duration: '5:22',
    isPremium: false,
    likes: 6701,
    topic: 'Prompt Engineering',
  ),
  VideoEntity(
    id: 'v4',
    title: 'How Large Language Models Work',
    expertName: 'Priya Sharma',
    expertImageUrl: _avatar(4),
    thumbnailUrl: _thumb(4),
    videoUrl: _yt4,
    duration: '6:05',
    isPremium: true,
    likes: 2940,
    topic: 'LLMs',
  ),
  VideoEntity(
    id: 'v5',
    title: 'Deep Learning in 5 Minutes',
    expertName: 'James Okafor',
    expertImageUrl: _avatar(5),
    thumbnailUrl: _thumb(5),
    videoUrl: _yt5,
    duration: '4:58',
    isPremium: false,
    likes: 5310,
    topic: 'Deep Learning',
  ),
];

final mockWorkshops = <WorkshopEntity>[
  WorkshopEntity(
    id: 'w1',
    title: 'AI Product Strategy Bootcamp',
    host: 'Dr. Sarah Jenkins',
    date: 'Jun 18, 2025',
    time: '3:00 PM IST',
    isFree: true,
    spotsLeft: 12,
    imageUrl: _prog(1),
  ),
  WorkshopEntity(
    id: 'w2',
    title: 'LLM Fine-Tuning Masterclass',
    host: 'Marcus Chen',
    date: 'Jun 22, 2025',
    time: '6:00 PM IST',
    isFree: false,
    spotsLeft: 5,
    imageUrl: _prog(2),
  ),
  WorkshopEntity(
    id: 'w3',
    title: 'Prompt Chains for Developers',
    host: 'Elena Rodriguez',
    date: 'Jun 25, 2025',
    time: '4:30 PM IST',
    isFree: true,
    spotsLeft: 28,
    imageUrl: _prog(3),
  ),
];

final mockJobs = <JobEntity>[
  JobEntity(
    id: 'j1',
    title: 'Senior ML Engineer',
    company: 'Deepmind',
    location: 'London, UK',
    type: 'Full-time',
    salary: '\$160K – \$200K',
    logoUrl: _avatar(10),
    isRemote: true,
    postedAgo: '2 days ago',
  ),
  JobEntity(
    id: 'j2',
    title: 'AI Product Manager',
    company: 'OpenAI',
    location: 'San Francisco',
    type: 'Full-time',
    salary: '\$180K – \$220K',
    logoUrl: _avatar(11),
    isRemote: false,
    postedAgo: '1 day ago',
  ),
  JobEntity(
    id: 'j3',
    title: 'Prompt Engineer',
    company: 'Anthropic',
    location: 'Remote',
    type: 'Contract',
    salary: '\$120K – \$140K',
    logoUrl: _avatar(12),
    isRemote: true,
    postedAgo: '5 hours ago',
  ),
  JobEntity(
    id: 'j4',
    title: 'Cybersecurity Analyst',
    company: 'Cloudflare',
    location: 'Austin, TX',
    type: 'Full-time',
    salary: '\$100K – \$130K',
    logoUrl: _avatar(13),
    isRemote: false,
    postedAgo: '3 days ago',
  ),
];