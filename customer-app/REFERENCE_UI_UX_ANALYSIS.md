# Reference UI/UX Analysis

Source: `WhatsApp Video 2026-09-17 at 9.15.26 AM.mp4` (49s, 720x720, iOS simulator capture of a Flutter app internally named "shortsapp" / "FixlyApp"). Frames extracted at 2fps for inspection.

This is a UI/UX reference only. Fake data seen in the video (worker "Ravi Kumar", "CleanPro", ratings, prices, ETA) must **never** appear in our app — it exists here only to describe layout/behavior.

## Global design language

- **Background**: pure white (`#FFFFFF`) everywhere; no gradients, no colored hero headers.
- **Primary accent**: vivid blue, ~`#2F5FE0`–`#3B6FEA` range. Used for: selected states, primary buttons, active tab underline, links, progress ring.
- **Text**: near-black (`#1F2937`-ish) for primary text, mid-gray (`#6B7280`-ish) for secondary/meta text.
- **Cards**: white surface, thin light-gray border or very soft shadow, radius ~16px.
- **Buttons**: full-width, solid blue, radius ~14-16px, height ~52px, label + trailing arrow glyph (`→`) baked into text, e.g. "Book Now →", "Confirm Booking →", "Pay & Confirm →".
- **Selection pattern** (dates, times, categories/tabs, payment method, gig checkboxes): unselected = white/light-gray surface with thin border + dark text; selected = solid blue fill + white text, or blue border + blue checkmark for list-style single-select rows.
- **Top bar**: back chevron (circular light-gray hit target) + centered/left title, no elevation, transparent/white.
- **Status bar style**: light content off white background (dark icons).
- **Icons**: simple line icons (outline style), not filled, muted gray when inactive.
- **Bottom navigation**: 4-5 items, active = blue icon+label, inactive = gray, simple line icons (home, calendar/bookings, heart/favorites, person/profile).

## Screen-by-screen

### 1. Onboarding (~0:00–0:02)
- Purpose: first-run intro.
- Top-right: "Skip" text link.
- Center illustration: friendly cartoon handyman/worker character with small floating pastel-circle icons around him representing services (paint roller, water drop/plumbing, lightbulb/electrical, wrench).
- Heading: "Home Services" (dark, bold) / "Made Simple" (blue, bold) stacked two lines.
- Subtext: "Book trusted professionals for everything your home needs." (gray, centered).
- Bottom: dot page-indicator (3 dots, first active).
- CTA: full-width blue rounded button "Get Started →".
- Navigation: → Home (after auth, in our real app this sits before/around auth).

### 2. Home (~0:03)
- Top-left: "Hello, {FirstName} 👋" (bold, dark).
- Line below greeting: "What service do you need today?" (gray, small).
- Location row: pin icon + "{City}, {State}" + chevron-down (tappable, opens address/location picker).
- Top-right: bell/notification icon (outline, dark).
- Search bar: rounded pill, light-gray fill, placeholder "Search for services...", trailing filter icon (sliders) in a separate small square button.
- **Service categories grid**: 4 columns x 2 rows, each cell = soft pastel rounded-square icon tile (different pastel color per category) + label below (Cleaning, Plumbing, Electrician, Painting, AC Service, Carpentry, Pest Control, More).
- **Promo banner**: single large rounded image card with dark overlay text ("...% OFF") + "Book Now" pill button, full-bleed image.
- **Popular Services** section header with "See All" link, followed by horizontally scrollable large image cards (service photo, title, price) — cut off in video before detail visible.
- Bottom nav: Home / Bookings / Favorites / Profile (4 tabs, icons only + label, active tab blue).

### 3. Service Category / Listing screen (~0:04–0:05)
- Top bar: back chevron, centered title "Cleaning Services", search icon top-right.
- Location line under top bar (small, gray) — carried over context.
- **Tab/chip selector row**: "All" / "Home" / "Office" / "Deep Cleaning" — pill chips, selected = blue fill white text, unselected = white/light-gray outline dark text. Horizontally scrollable.
- **Worker/gig list** — vertical stack of white rounded cards, each containing:
  - small circular/rounded worker photo (left)
  - worker name (bold)
  - rating (star icon + number) + review count in parens + distance ("2.1 km") on one meta line
  - service tag line (e.g. "Home Cleaning, Deep Cleaning, Sofa Cleaning")
  - "From ₹{price}" (bold, left)
  - "Book" pill button (blue, right, compact, on the same row as price)
- Cards are compact height (~90-100px), generous vertical spacing between them (~12px).

### 4. Worker Profile (~0:06–0:09)
- Full-bleed hero photo at top (worker at work), height ~35% of screen.
- Floating circular buttons over the hero: back (top-left), share + heart/favorite (top-right, two separate circular white/blur buttons).
- Below hero, a white rounded-top sheet overlaps the image slightly:
  - Worker name (large, bold)
  - Rating row: star + "4.8 (320 reviews)" + distance "2.1 km" muted
  - One-line tagline in muted gray ("Professional. Reliable. Trusted.")
  - **Tabs**: "About" / "Services" / "Reviews" — underline-style tab selector, active tab blue text + blue underline, inactive gray text.
  - **About tab**: paragraph description (muted gray) + a highlighted assigned-professional row/card ("Assigned professional: {name}") in a light surface box.
  - **Services tab**: vertical list of gigs as selectable rows — each row: checkbox/radio circle (left), service name, price (right, bold). Selected row gets a blue border around the whole row plus filled blue check. Multiple gigs listed (Home Cleaning, Deep Cleaning, Sofa Cleaning, Bathroom Cleaning, Kitchen Cleaning...).
  - **Reviews tab**: not fully shown in this clip but structurally implied (see spec §16).
- Sticky bottom bar: price on left (large, bold, "₹{price}"), "Book Now →" blue button on right, contained in a subtly bordered top strip.

### 5. Book a Service (~0:10)
- Top bar: back chevron + "Book a Service" title.
- Worker/gig summary card: small round photo, worker name, gig name (muted below name), price top-right of the row.
- **Select Date** section: horizontal row of 4 date chips (Today, Wed, Thu, Fri with day/date sub-label), rounded rectangle chips, selected = blue fill white text, unselected = white bordered dark text.
- **Select Time** section: 2x2 (or wrapping) grid of time chips (9:00 AM, 11:00 AM, 1:00 PM, 3:00 PM), same selected/unselected treatment as dates.
- **Address** section header with "Change" link top-right; below, a card: home icon + "Home" bold + address line muted.
- **Special Instructions (Optional)** section: large rounded multi-line text field, placeholder "e.g. Focus on kitchen and bathroom...".
- Bottom sticky CTA: full-width blue "Confirm Booking →".
- No explicit "Total Amount" row was visible before Confirm on this screen in the captured frames (it appears in Payment).

### 6. Payment (~0:11–0:13)
- Top bar: back chevron + "Payment" title.
- **Booking Summary** card: rows for Provider, Service, Date, Time, Address, Total — label left (muted) value right (dark, Total bolded and larger).
- **Payment Method** section: vertical list of selectable method cards — UPI, Card, PayPal, Apple Pay. Each card: icon (left, in colored rounded square), title + subtitle (e.g. "GPay, PhonePe, Paytm"), radio indicator (right). Selected card gets a blue border + filled blue radio.
- Bottom sticky CTA: "Pay & Confirm →", shows an inline loading spinner in place of the label while processing (button stays same size/position, spinner centered).
- **Product note**: PayPal/Apple Pay are visual-only in the reference; our implementation only wires up what Razorpay actually supports (UPI, Card, netbanking/wallet as Razorpay provides) — see spec constraint in §20.

### 7. Booking Details / Confirmed (~0:14)
- Top bar: back chevron + "Booking Details" title.
- Worker summary row: photo, name, booking id/reference muted under name.
- Details card: Provider, Service, Date, Time, Address, Total rows (label/value pairs).
- Bottom CTA: "Track Provider →".
- (The dedicated full-screen green-check "Booking Confirmed!" success state from spec §21 was not explicitly captured in this clip's frame sample — it likely occurs in the ~1s gap between Payment and Booking Details. Implement per spec §21 regardless: large green check, "Booking Confirmed!", summary card, "Track Provider" + "View Booking" buttons.)

### 8. Service on the Way (~0:15–0:17)
- Title bar: back chevron + "Service on the way".
- **Map** occupies top ~55% of screen: light/minimal map style, customer marker (home pin, blue circle) static, worker marker (small circular avatar in dark circle) animates along a drawn route polyline (blue) toward the customer marker.
- Floating pill at top of map: "{N} min away" countdown, updates as marker approaches (7 min → 3 min → 1 min observed).
- Below map, floating white rounded-top card:
  - worker row: photo, name, rating+status muted ("4.8 (320) · On the way"), call icon button + chat icon button (right, circular light-gray backgrounds).
  - **Status timeline**: vertical list with filled/outline blue dots — "Booking Confirmed" (filled, timestamp right), "Provider on the way" (filled, timestamp right), "Service in Progress" (outline/pending), "Completed" (outline/pending).
  - "Service Details" link (centered, small, blue).
  - Bottom sticky CTA: "Start Service →" (enabled once worker arrives / per backend state).

### 9. Service in Progress (~0:18–0:20)
- Top bar: back + "Service in Progress".
- Centered **circular progress ring** (blue arc growing), with digital timer text in the center ("00:00:06" format, counting up) and "Service Time" caption below the number.
- Below the ring: two overlapping circular avatars (worker illustration + worker photo) stacked/side-by-side, worker name + rating below.
- Summary card: Service name + price (row 1), Date (row 2), Start Time (row 3).
- Two side-by-side outline buttons: "Chat" / "Call".
- Bottom CTA: outline (not filled) red/blue-bordered button "Complete Service →" — visually distinct (outlined) from the primary filled CTAs elsewhere, signaling a terminal/careful action.

### 10. Rate Your Experience (~0:21)
- Top bar: back + "Rate Your Experience".
- Centered worker illustration (thumbs-up pose) + "Great Service!" heading (bold).
- Subtext: "How was your experience with {worker}?" (muted, centered).
- **5-star selector**: large outline stars, tapping fills stars up to selection in blue/gold; animates fill on tap.
- Large rounded textarea: placeholder "Tell us about your experience...".
- Bottom CTA: "Submit Review →".

### 11. Service Completed (~0:22)
- Centered green circular check-mark icon (success).
- "Service Completed!" heading (bold).
- Subtext: "Thanks for using {AppName}." muted.
- Compact one-line summary: "{Provider} · {Service} · ₹{price}".
- Two stacked full-width buttons: "View Bookings" (filled blue), "Back to Home" (outline).
- Below that (still on this screen, scroll or same viewport): a promotional illustration banner ("Better Homes Happier Lives") — **only include this if backed by real configured promo content; otherwise omit** per no-fake-content rule.
- Navigation: → Home (confirmed: last frame returns to Home screen identical to screen #2).

## Transition graph (as observed)

```
Onboarding --Get Started--> Home
Home --tap category--> Category/Listing
Category/Listing --tap worker card "Book"/card tap--> Worker Profile
Worker Profile (Services tab, select gig) --Book Now--> Book a Service
Book a Service --Confirm Booking--> Payment
Payment --Pay & Confirm (success)--> Booking Confirmed (success state) --> Booking Details
Booking Details --Track Provider--> Service on the Way (live map)
Service on the Way --worker arrives / Start Service--> Service in Progress
Service in Progress --Complete Service--> Rate Your Experience
Rate Your Experience --Submit Review--> Service Completed
Service Completed --Back to Home / auto--> Home
```

## Reusable components implied by the reference

- `PillChip` (date/time/category/tab selector, blue-selected / gray-unselected)
- `PrimaryButton` (full-width, blue, trailing arrow glyph)
- `OutlineButton` (Chat/Call pair, Complete Service, Back to Home)
- `SelectableListRow` (payment method, gig selection — leading icon/checkbox, title+subtitle, trailing radio/check, blue border when selected)
- `WorkerCard` (list card: avatar, name, rating+reviews+distance, tags, price, Book button)
- `WorkerHeroProfile` (full-bleed image + floating circular icon buttons + overlapping bottom sheet)
- `SectionHeader` (title + optional "See All"/"Change" trailing link)
- `StatusTimeline` (dot + label + timestamp, filled vs outline states)
- `FloatingMapCard` (rounded-top white panel docked to bottom of a map view)
- `CircularProgressTimer` (ring + centered elapsed time)
- `StarRatingInput` (tap-to-select, animated fill)
- `SuccessState` (green check + heading + subtext + summary + actions)
- `CategoryIconTile` (pastel rounded-square icon + label)

## Known gap vs. current codebase

The existing `lib/app/theme/app_colors.dart` and `lib/features/home/home_screen.dart` use an indigo/violet **gradient hero header** (`AppColors.primaryViolet` → `AppColors.darkIndigo`) with white text on a colored `SliverAppBar`. This does not match the reference, which uses a **flat white background with plain dark-text greeting** and blue used only as an accent on interactive elements. The design system needs to be retuned (Phase 2) before screen work begins, per implementation order in the product spec.
