# VaultPay – Vulnerable iOS Application Security Lab

VaultPay is a **deliberately vulnerable iOS application** designed for **learning and practicing iOS application security testing**.

🚨 **Important Design Note**

- ❌ No backend server  
- ❌ No database  
- ❌ No API-based authentication  
- ✅ All logic, authentication, and authorization are handled **entirely on the client side**

This design is **intentional** and allows learners to clearly understand how
**client-side trust and insecure coding practices lead to serious security flaws** in real-world iOS applications.

⚠️ **This application is intentionally insecure. Do NOT use in production.**

---

## 🎯 Purpose of This Lab

The primary goal of VaultPay is to help learners understand:

- How insecure iOS app designs are exploited
- Why client-side security controls are insufficient
- How attackers bypass common mobile security mechanisms
- How real-world mobile pentest findings look in practice

VaultPay simulates a **digital wallet / transaction-based mobile app**, intentionally implemented with **realistic security misconfigurations** frequently observed during mobile VAPT engagements.

---

## 🛠 Technology Stack

- Language: **Swift**
- UI Framework: **SwiftUI**
- Platform: **iOS 15+**
- Device: Simulator & physical devices
- Jailbreak: Required for advanced runtime attacks (not all)

Most vulnerabilities can be identified **without a jailbroken device**, making this lab suitable for **beginners and intermediate learners**.

---

## 🧠 Application Workflow Overview

1. **App Launch**
   - A jailbreak detection check is executed
   - If a jailbreak is detected, an access-denied screen is shown
   - This protection is implemented purely on the client side

2. **Login Screen**
   - Accepts any username and password
   - Creates a local session
   - User is logged in with **non-admin privileges**

3. **Privilege Escalation**
   - Authentication and role are stored locally
   - By modifying local values, admin access can be obtained

4. **Admin Dashboard**
   - Exposes sensitive features:
     - Network communication
     - Transactions (biometric protected)
     - Wallet secrets (Keychain)

5. **Supporting Misconfigurations**
   - Insecure file sharing & backups
   - Excessive logging of sensitive data

This workflow demonstrates how **multiple small weaknesses combine into a full compromise**.

---

## 🚨 Included Vulnerabilities

The following vulnerabilities are **intentionally included** for learning purposes:

1. Weak Jailbreak Detection (Client-Side Enforcement)
2. Insecure Authentication and Authorization via Local Storage
3. Broken SSL Pinning (Client-Side Trust)
4. Biometric Authentication Bypass
5. Insecure Use of Secure Storage (Keychain Misuse)
6. Insecure Backup and File Sharing Configuration
7. Excessive Application Logging (Sensitive Information Disclosure)

---

## 1️⃣ Weak Jailbreak Detection (Client-Side Enforcement)

### Description
VaultPay performs a jailbreak detection check at launch. However, the logic is enforced entirely on the client side and lacks tamper resistance.

### Why It’s Vulnerable
- Detection logic exists only in app code
- Result is trusted without validation
- UI flow is controlled by a single boolean
- No runtime integrity checks

### Exploitation (Jailbroken Device)
- Identify the jailbreak detection function
- Force it to return a safe value at runtime
- Bypass the access-denied screen
- Continue using the app normally

### Impact
Allows the app to run in an untrusted environment, enabling further exploitation.

---

## 2️⃣ Insecure Authentication and Authorization via Local Storage

### Description
VaultPay uses local storage (`UserDefaults`) to decide authentication state and user role.

### How It Is Implemented
- `isLoggedIn` determines authentication
- `role` determines privilege level
- Both values are stored locally and trusted blindly

### Exploitation (Jailbroken Device)
- Access the app’s sandbox
- Modify stored authentication values
- Relaunch the app
- Gain **admin access without valid credentials**

### Why This Works
- No backend validation
- No integrity checks
- Role-based access enforced entirely on the client

---

## 3️⃣ Broken SSL Pinning (Client-Side Trust)

### Description
The app implements SSL pinning using a custom `URLSession` trust evaluation.

### Why It’s Vulnerable
- Trust decisions are made locally
- No protection against runtime hooking
- No server-side enforcement

### Exploitation (Jailbroken Device)
- Hook the trust evaluation logic
- Force certificate validation to succeed
- Intercept HTTPS traffic using Burp Suite

### Impact
- Encrypted traffic interception
- Request and response manipulation

---

## 4️⃣ Biometric Authentication Bypass

### Description
Biometric authentication protects access to the Transactions feature.

### Why It’s Vulnerable
- Authorization depends on a client-side flag
- Logic enforced in UI layer
- No backend or session validation

### Exploitation
- Hook biometric success callbacks
- Force navigation flag to allow access
- Access transactions without valid biometrics

### Impact
Sensitive features accessible without user verification.

---

## 5️⃣ Insecure Use of Secure Storage (Keychain Misuse)

### Description
Sensitive secrets are stored in the iOS Keychain without additional access controls.

### Why It’s Vulnerable
- No biometric protection
- No user presence requirement
- Secrets accessible at runtime

### Exploitation (Jailbroken Device)
- Attach runtime instrumentation
- Enumerate Keychain items
- Dump secrets in plaintext

---

## 6️⃣ Insecure Backup and File Sharing Configuration

### Description
File sharing and backups are enabled via `Info.plist`.

### Why It’s Vulnerable
- App container can be extracted
- Documents directory is accessible
- No backup exclusions applied

### Exploitation (No Jailbreak Required)
- Connect device to Xcode
- Download app container
- Extract stored files and data

---

## 7️⃣ Excessive Application Logging

### Description
VaultPay logs sensitive internal state using unrestricted debug statements.

### Exposed Information
- Authentication state
- User roles
- Security decisions
- Internal logic flow

### Exploitation
- View logs via Xcode or Console.app
- Gain insight into app security behavior
- Use leaked data to chain attacks

---

## ⬇️ Download

A compiled **IPA** is available under **GitHub Releases**.

➡️ Go to **Releases** → download `VaultPay.ipa`

---

## 📦 Installation (iOS)

Due to iOS restrictions, direct installation is not supported.

Recommended method:
1. Install **AltStore**
2. Download `VaultPay.ipa` from Releases
3. Open AltStore → My Apps → ➕
4. Install the IPA and trust the app

---

## 🎓 Intended Audience

- iOS Security Beginners
- Mobile Application Pentesters
- VAPT Learners
- Security Researchers

---

## ⚠️ Disclaimer

This project is for **educational purposes only**.
The author is not responsible for any misuse of this application.
