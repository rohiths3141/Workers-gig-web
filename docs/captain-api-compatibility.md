# Fixura / KaushalSetu — Captain Mobile App API Compatibility Matrix

This document provides a comprehensive audit of the existing backend API (`apps/api`) running on port 5000, and specifies how the **Captain Mobile App** (`captain_app/`) consumes, maps, and integrates each endpoint.

---

## 1. API Compatibility Matrix

| Feature Area | Endpoint | HTTP Method | Exists in Backend | Request / Response Contract Known | Captain App Support | Notes / Integration Mapping |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- |
| **Auth** | `/api/v1/auth/register` | `POST` | ✓ | ✓ | ✓ | Worker registration with `role: "WORKER"`, phone, password, full name. |
| **Auth** | `/api/v1/auth/login` | `POST` | ✓ | ✓ | ✓ | Phone & password login. Returns JWT token and worker metadata. |
| **Auth / Session** | `/api/v1/auth/me` | `GET` | ✓ | ✓ | ✓ | Reconciles server profile, KYC, BGV, RPL, qualifications, and active insurance. |
| **Localization** | `/api/v1/auth/language` | `PATCH` | ✓ | ✓ | ✓ | Syncs worker language preference (`en`, `ta`, `hi`). |
| **Captain Profile** | `/api/v1/workers/:id` | `GET` | ✓ | ✓ | ✓ | Public/private worker profile with ratings, reviews, badges, and completed jobs. |
| **Availability** | `/api/v1/workers/ready-to-work` | `PATCH` | ✓ | ✓ | ✓ | Toggles `isReadyToWork: true/false`. Authoritative check enforced on server. |
| **KYC** | `/api/v1/workers/kyc-verify` | `POST` | ✓ | ✓ | ✓ | Submits document type (`AADHAAR`, `VOTER_ID`, `PAN`) and number. Returns masked number and `status: VERIFIED`. |
| **RPL Qualification** | `/api/v1/workers/rpl-verify` | `POST` | ✓ | ✓ | ✓ | Submits certificate number and sector code. Integrates with MockRplProvider. |
| **RPL Pathway** | `/api/v1/workers/rpl-pathway` | `GET` | ✓ | ✓ | ✓ | Returns educational/guidance steps for uncertified workers. |
| **Services / Trades** | `/api/v1/services` | `GET` | ✓ | ✓ | ✓ | Retrieves available trade categories (Electrician, Plumber, Carpenter, etc.). |
| **Job Offers** | `/api/v1/service-requests/my` | `GET` | ✓ | ✓ | ✓ | For role `WORKER`, returns service requests offered as candidate matches. |
| **Bookings List** | `/api/v1/bookings/my/list` | `GET` | ✓ | ✓ | ✓ | Returns active and historical bookings assigned to the authenticated worker. |
| **Booking Detail** | `/api/v1/bookings/:id` | `GET` | ✓ | ✓ | ✓ | Complete booking details, address, OTP verification record, customer profile. |
| **Booking Transition**| `/api/v1/bookings/:id/status` | `PATCH` | ✓ | ✓ | ✓ | Transitions status through `BookingStateMachine` (`TRAVELING`, `IN_PROGRESS`, `COMPLETED`). |
| **Doorstep Arrival OTP**| `/api/v1/bookings/:id/verify-arrival` | `POST` | ✓ | ✓ | ✓ | Validates 4-digit arrival OTP against server hash with rate-limiting and expiry. |
| **Job Photos** | `/api/v1/bookings/:id/photos` | `POST` | ✓ | ✓ | ✓ | Stores work area evidence (`BEFORE_JOB`, `AFTER_JOB`) with URLs. |
| **Materials Request** | `/api/v1/materials/request` | `POST` | ✓ | ✓ | ✓ | Worker creates material procurement request with item name and estimated cost. |
| **Materials Receipt** | `/api/v1/materials/:id/bill` | `POST` | ✓ | ✓ | ✓ | Worker uploads bill receipt URL and actual item cost. |
| **Damage Incident** | `/api/v1/claims` | `POST` | ✓ | ✓ | ✓ | Non-punitive incident logging under Fixura Shield Client Protection. |
| **Damage Claim Detail**| `/api/v1/claims/:id` | `GET` | ✓ | ✓ | ✓ | Returns damage claim, evidence photos, status, and assessment notes. |
| **Worker Claim Response**| `/api/v1/claims/:id/worker-response`| `POST` | ✓ | ✓ | ✓ | Worker submits statement/explanation without fear of automatic penalties. |
| **Worker Insurance** | `/api/v1/insurance/my` | `GET` | ✓ | ✓ | ✓ | Fetches active Suraksha Raksha worker insurance policy and claims. |
| **Insurance Claim** | `/api/v1/insurance/claim` | `POST` | ✓ | ✓ | ✓ | Submits worker accident/injury claim with amount claimed and medical bills. |
| **Wallet & Ledger** | `/api/v1/wallet/my` | `GET` | ✓ | ✓ | ✓ | Authoritative balance, double-entry immutable transactions, and payout requests. |
| **Withdrawal / Payout** | `/api/v1/wallet/payout` | `POST` | ✓ | ✓ | ✓ | Requests payout via UPI or Bank Transfer with atomic concurrency deduction. |
| **Two-Sided Ratings** | `/api/v1/ratings` | `POST` | ✓ | ✓ | ✓ | Captain rates Customer (1-5 stars, communication, workplace safety, payment). |
| **Support Tickets** | `/api/v1/support/tickets` | `POST` | ✓ | ✓ | ✓ | Logs support ticket or Emergency SOS incident. |
| **Support List** | `/api/v1/support/tickets/my` | `GET` | ✓ | ✓ | ✓ | Worker's open and resolved support tickets. |
| **Support Reply** | `/api/v1/support/tickets/:id/messages`| `POST` | ✓ | ✓ | ✓ | Message thread in support ticket. |

---

## 2. Discovered Endpoint Gaps & Clean Adapters

1. **Push Notifications:**
   - The backend does not currently include a Firebase Cloud Messaging (FCM) or Apple Push Notification Service (APNS) registration endpoint.
   - *Captain App Solution:* Provided `NotificationProvider` abstraction with local in-app deep linking and simulated background trigger adapters.
2. **Direct File / Multipart Photo Upload:**
   - The backend currently accepts URLs for photos/bills (e.g. `photoUrl`, `billReceiptUrl`, `medicalBillsUrl`).
   - *Captain App Solution:* Created a `FileUploadService` abstraction with local image compression and storage preview, returning URI identifiers ready for direct S3/Cloudinary presigned URLs or base64 data URIs.
3. **SMS OTP Delivery for Login:**
   - The backend currently uses phone + password for worker authentication in `/api/v1/auth/login` and `/api/v1/auth/register`, while doorstep arrival verification uses the cryptographically secure 4-digit OTP via `/api/v1/bookings/:id/verify-arrival`.
   - *Captain App Solution:* The login screen supports phone + OTP verification flow (with a client-side countdown timer and demonstration OTP provider) as well as password authentication.

---

## 3. Base URL & Network Configuration

The Captain app configures API base URLs dynamically:
- **Android Emulator:** `http://10.0.2.2:5000/api/v1`
- **Windows / Web / Desktop:** `http://localhost:5000/api/v1`
- **Physical Device:** `http://<YOUR-LAN-IP>:5000/api/v1`
- **CLI Override:** `--dart-define=API_URL=http://your-server:5000/api/v1`
