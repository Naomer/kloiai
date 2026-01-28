# Kloi
## Screenshots

### Authentication & Onboarding

<p float="left">
 
  <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7510.JPG?raw=1" width="220" />
  <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7509.JPG?raw=1" width="220" />
  <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7508.JPG?raw=1" width="220" />
</p>

<p float="left">
  
</p>

---

### Profile & Settings

<p float="left">
 
  <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7501.JPG?raw=1" width="220" />
   <img src="https://github.com/Naomer/kloiai/blob/445fa48c7b75169cc6cfeab2c868f389b0439dca/IMG_7494.JPG?raw=1" width="220" />
  <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7499.JPG?raw=1" width="220" />
  <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7500.JPG?raw=1" width="220" />
</p>

---

### App Flow & Home

<p float="left">

  <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7504.JPG?raw=1" width="220" />
  <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7505.JPG?raw=1" width="220" />
  <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7507.JPG?raw=1" width="220" />
   <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7498.JPG?raw=1" width="220" />
  <img src="https://github.com/Naomer/kloiai/blob/f2d05d2b57e62477b3d8778b6bba990f9a32a371/IMG_7497.JPG?raw=1" width="220" />
</p>



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

