# TempInbox

## Overview
A disposable email app: users get an instant random address, receive real emails, and read or delete them. Built for people who want to sign up for things without exposing their real inbox.

## Built vs Coming Soon
- Built: auto-created address, copy, new address, live inbox (10 s polling + pull to refresh), read email, swipe/button delete
- Coming soon: none requested
- No custom backend: uses the public TemporaryMail API directly
- Limitation: the API lists sender, subject and time only (no body endpoint); delete and read state are local to the device

## Tech Stack & Key Decisions
- TemporaryMail public API (temporarymail.com/api) via `http`: requestEmailAccess returns address + secretKey, checkInbox returns `[]` or a map of id to summary
- Provider + ChangeNotifier; InboxProvider is app-global because the message screen reads/updates the same state
- go_router: `/` inbox, `/message/:id` detail
- shared_preferences stores address + secretKey so the same mailbox is restored on relaunch

## Architecture
- UI → InboxProvider → InboxService (restore, sorting) → MailRepository (HTTP + prefs)
- Repository throws MailApiException with server detail; provider stores it and screens show it with retry
- Restore: saved key is verified with checkInbox on launch; an API error clears it and a new address is created
- Provider keeps seen/removed id sets and applies them after every refresh, since the server has no such state

## Conventions
- The message screen reads the already-loaded list item; there is no per-message fetch

## Key Patterns & Gotchas
- temporarymail.com may not send CORS headers; in the web preview requests can fail and the error state shows — devices work
- openMessage runs in a post-frame callback to avoid notifying during build
- Polling timer is cancelled/restarted around new-address creation

## Design System
- Dark-first, privacy feel: deep navy surfaces, teal→indigo hero gradient for the address card
- Space Grotesk for headings (techy character), Inter for body legibility
- 4/8/16/24/32 spacing rhythm; large 28 px radius on hero, 16 px on tiles
