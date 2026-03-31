# phloxCert_movePackages

**Move smart contract package for PhloxCert / IOTA notarization registry.**

This folder contains the Move package responsible for:
- registering users/locations (via `LocalRegistry`)
- storing registry data on the IOTA Move chain

> This package is intended to be built and deployed using the IOTA Move toolchain.

---

## 📦 Setup

### 1) Build
From the `register_contract` directory:
```bash
cd register_contract
iota move build
```

### 2) Test
```bash
iota client publish --gas-budget 20000000
```

---

## 🧩 Notes
- The contract IDs used by frontend/backend must match the deployed package and registry object IDs.
