
🚀 Kloi
A fast, secure, mobile‑first app built with Flutter and Supabase, featuring modern authentication, email OTP, and seamless user profiles.

Built for speed without sacrificing correctness.

✨ Features
🔐 Authentication

Email OTP (passwordless, mobile‑friendly)

Google Sign‑In

Secure email change with verification

Optional password support

👤 User Profiles

Create & edit profile (name, avatar)

Profile auto‑creation on first login

📱 Mobile‑First UX

No browser redirects

In‑app OTP verification

Clean, minimal auth flow

🛡 Security

Supabase Row Level Security (RLS)

Secure email & password changes

Ready for 2FA / MFA extension

⚡ Fast by Design

Lightweight auth flow

Instant session handling

Optimized navigation after login

🧱 Tech Stack
Flutter (mobile app)

Supabase

Auth (Email OTP, Google)

PostgreSQL

Row Level Security (RLS)

Dart

🔐 Authentication Flow (Mobile)
Email OTP (Primary)
User enters email

Receives 6‑digit verification code

Enters code in the app

Logged in instantly (no browser)

Magic links are reserved for web only

Google Sign‑In
Native Google OAuth

No manual setup required for users

🗂 Database Structure
auth.users
Handled automatically by Supabase.

profiles
id UUID PRIMARY KEY REFERENCES auth.users(id)
full_name TEXT
avatar_url TEXT
created_at TIMESTAMP
Profile row is auto‑created if missing

Uses UPSERT to avoid edge cases

🔒 Row Level Security (RLS)
Required policies for profiles:

-- Read own profile
id = auth.uid()

-- Update own profile
id = auth.uid()
This ensures users can only access their own data.

⚙️ Environment Setup
Create a .env file:

SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
Make sure these are also configured in your Supabase project:

Site URL

Email provider enabled

Email templates using {{ .Token }} for OTP

📧 Email Configuration Notes
OTP vs Magic Link is controlled by email templates

For mobile OTP:

Use {{ .Token }}

Remove {{ .ConfirmationURL }}

Secure email change requires:

OTP to current email

OTP to new email

🚧 Roadmap
 Two‑Factor Authentication (TOTP)

 Account deletion flow

 Session management UI

 Custom SMTP for production

 Web app version

🧠 Design Philosophy
Speed matters

No broken auth flows

No unnecessary browser redirects

Mobile UX comes first

Security is non‑negotiable

📄 License
MIT License
Feel free to use, modify, and build on top of this project.

If you want, next I can:

Add badges (Flutter, Supabase, License)

Make a shorter README for landing pages

Write a CONTRIBUTING.md

Customize this for open‑source vs startup

Just say which one 🔥


Show less






no i want fully copy not like this i want the correct one

ChatGPT2:48 AM
Got it 👍
You want a final, fully copy‑pasteable README — no commentary, no “like this”, no teaching tone.
Below is a clean, production‑ready README.md exactly as it should live in the repo.

You can copy everything from # Kloi down and paste it directly.

# Kloi

Kloi is a fast, mobile‑first application built with Flutter and Supabase, focused on secure authentication, clean UX, and production‑ready architecture.

The app is designed to work natively on mobile without browser redirects, using in‑app email OTP verification and modern OAuth providers.

---

## Features

- Email authentication with OTP (passwordless, mobile‑friendly)
- Google Sign‑In
- Secure email change with verification
- User profiles with editable name and avatar
- Automatic profile creation on first login
- Clean auth → profile → home navigation
- Supabase Row Level Security (RLS)
- Ready for MFA / 2FA expansion

---

## Tech Stack

- Flutter
- Dart
- Supabase
  - Supabase Auth
  - PostgreSQL
  - Row Level Security (RLS)

---

## Authentication

### Email OTP (Mobile)

1. User enters email
2. Supabase sends a one‑time verification code
3. User enters the code in the app
4. User is signed in without leaving the app

Magic links are reserved for web usage only.

### Google Sign‑In

- Native Google OAuth
- No external browser redirects
- Automatically links to the user profile

---

## Database Schema

### profiles table

```sql
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  avatar_url text,
  created_at timestamp with time zone default now()
);
One profile per authenticated user

Created automatically if missing

Updated using UPSERT to avoid edge cases

Row Level Security (RLS)
Required policies for the profiles table:

-- Allow users to read their own profile
create policy "Read own profile"
on profiles for select
using (id = auth.uid());

-- Allow users to update their own profile
create policy "Update own profile"
on profiles for update
using (id = auth.uid());
Environment Variables
Create a .env file in the project root:

SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
SUPABASE_ANON_KEY=YOUR_PUBLIC_ANON_KEY
Supabase Configuration Notes
Enable Email provider in Authentication → Providers

Email templates must use {{ .Token }} for OTP

Remove {{ .ConfirmationURL }} for mobile flows

Enable Secure Email Change if allowing email updates

Set a valid Site URL in project settings

For production, configure a custom SMTP provider

Project Structure
lib/
├─ features/
│  ├─ auth/
│  ├─ profile/
│  └─ security/
├─ services/
├─ core/
└─ main.dart
Roadmap
Two‑factor authentication (TOTP)

Account deletion

Session management screen

Web version

Custom SMTP for production delivery

Design Principles
Mobile first

No unnecessary browser redirects

Fast auth flow

Secure by default

Clean and maintainable codebase

License
MIT License


---

If you want next:
- a **short README** for landing pages  
- **badges** (Flutter, Supabase, MIT)  
- or a **CONTRIBUTING.md**

Say the word.
