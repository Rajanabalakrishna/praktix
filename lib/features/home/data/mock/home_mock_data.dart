import 'package:praktix/features/home/domain/entities/expert_entity.dart';
import 'package:praktix/features/home/domain/entities/job_entity.dart';
import 'package:praktix/features/home/domain/entities/program_entity.dart';
import 'package:praktix/features/home/domain/entities/video_entity.dart';
import 'package:praktix/features/home/domain/entities/workshop_entity.dart';

// ── YouTube embed URLs ────────────────────────────────────────────────────────
const _yt1 = 'https://www.youtube.com/embed/aircAruvnKk';
const _yt2 = 'https://www.youtube.com/embed/ukzFI9rgwfU';
const _yt3 = 'https://www.youtube.com/embed/7eh4d6sabA0';
const _yt4 = 'https://www.youtube.com/embed/GwIo3gDZCVQ';
const _yt5 = 'https://www.youtube.com/embed/PaCmpygFfXo';

// ── Human face avatars (randomuser.me — always returns real human photos) ─────
// gender: male / female  |  seed: any string for consistent same photo
String _female(String seed) =>
    'https://randomuser.me/api/portraits/women/${seed.hashCode.abs() % 50 + 1}.jpg';
String _male(String seed) =>
    'https://randomuser.me/api/portraits/men/${seed.hashCode.abs() % 50 + 1}.jpg';

// ── Video thumbnails — use YouTube's own thumbnail CDN (always topic-relevant) ─
// Format: https://img.youtube.com/vi/{VIDEO_ID}/hqdefault.jpg
const _thumb1 = 'https://img.youtube.com/vi/aircAruvnKk/hqdefault.jpg';
const _thumb2 = 'https://img.youtube.com/vi/ukzFI9rgwfU/hqdefault.jpg';
const _thumb3 = 'https://img.youtube.com/vi/7eh4d6sabA0/hqdefault.jpg';
const _thumb4 = 'https://img.youtube.com/vi/GwIo3gDZCVQ/hqdefault.jpg';
const _thumb5 = 'https://img.youtube.com/vi/PaCmpygFfXo/hqdefault.jpg';

// ── Workshop / program banners — topic-relevant Unsplash images ───────────────
const _workshopImg1 =
    'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400&h=160&fit=crop'; // AI/tech
const _workshopImg2 =
    'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=400&h=160&fit=crop'; // ML brain
const _workshopImg3 =
    'https://images.unsplash.com/photo-1555255707-c07966088b7b?w=400&h=160&fit=crop'; // code screen

// ── Company logos — use Clearbit logo API (returns real company logos) ────────
const _logoDeepmind  = 'https://logo.clearbit.com/deepmind.com';
const _logoOpenAI    = 'https://logo.clearbit.com/openai.com';
const _logoAnthropic = 'https://logo.clearbit.com/anthropic.com';
const _logoCloudflare= 'https://logo.clearbit.com/cloudflare.com';

// ─────────────────────────────────────────────────────────────────────────────

final mockExperts = <ExpertEntity>[
  ExpertEntity(
    id: 'e1',
    name: 'Dr. Sarah Jenkins',
    title: 'AI Strategy Consultant',
    imageUrl: _female('sarah'),       // ✅ real female face
    tags: ['Generative AI', 'Leadership'],
    isVerified: true,
    rating: 4.9,
    sessionRate: '\$120/hr',
  ),
  ExpertEntity(
    id: 'e2',
    name: 'Marcus Chen',
    title: 'VP of Machine Learning',
    imageUrl: _male('marcus'),        // ✅ real male face
    tags: ['LLMs', 'Architecture'],
    isVerified: true,
    rating: 4.8,
    sessionRate: '\$150/hr',
  ),
  ExpertEntity(
    id: 'e3',
    name: 'Elena Rodriguez',
    title: 'Applied Prompt Engineer',
    imageUrl: _female('elena'),       // ✅ real female face
    tags: ['NLP', 'UX Research'],
    isVerified: false,
    rating: 4.7,
    sessionRate: '\$90/hr',
  ),
  ExpertEntity(
    id: 'e4',
    name: 'Priya Sharma',
    title: 'Data Science Lead',
    imageUrl: _female('priya'),       // ✅ real female face
    tags: ['Python', 'Analytics'],
    isVerified: true,
    rating: 4.9,
    sessionRate: '\$110/hr',
  ),
  ExpertEntity(
    id: 'e5',
    name: 'James Okafor',
    title: 'Cybersecurity Architect',
    imageUrl: _male('james'),         // ✅ real male face
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
    expertImageUrl: _female('sarah'),
    thumbnailUrl: _thumb1,            // ✅ actual YouTube thumbnail
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
    expertImageUrl: _male('marcus'),
    thumbnailUrl: _thumb2,            // ✅ actual YouTube thumbnail
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
    expertImageUrl: _female('elena'),
    thumbnailUrl: _thumb3,
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
    expertImageUrl: _female('priya'),
    thumbnailUrl: _thumb4,
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
    expertImageUrl: _male('james'),
    thumbnailUrl: _thumb5,
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
    imageUrl: _workshopImg1,          // ✅ AI-relevant tech image
  ),
  WorkshopEntity(
    id: 'w2',
    title: 'LLM Fine-Tuning Masterclass',
    host: 'Marcus Chen',
    date: 'Jun 22, 2025',
    time: '6:00 PM IST',
    isFree: false,
    spotsLeft: 5,
    imageUrl: _workshopImg2,          // ✅ ML brain image
  ),
  WorkshopEntity(
    id: 'w3',
    title: 'Prompt Chains for Developers',
    host: 'Elena Rodriguez',
    date: 'Jun 25, 2025',
    time: '4:30 PM IST',
    isFree: true,
    spotsLeft: 28,
    imageUrl: _workshopImg3,          // ✅ coding screen image
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
    logoUrl: _logoDeepmind,           // ✅ real DeepMind logo
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
    logoUrl: _logoOpenAI,             // ✅ real OpenAI logo
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
    logoUrl: _logoAnthropic,          // ✅ real Anthropic logo
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
    logoUrl: _logoCloudflare,         // ✅ real Cloudflare logo
    isRemote: false,
    postedAgo: '3 days ago',
  ),
];