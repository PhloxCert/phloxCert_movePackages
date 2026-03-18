# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added
- **LocalRegistry Module**: Implementation of the shared `Registry` object for entity management.
- **Identity Registration**: Move logic for business and inspector registration with role-based attributes.
- **Notarization Integration**: Support for on-chain notarization objects linked to the IOTA ecosystem.
- **Initial package structure**.
- **Basic user management structures**.
- defined `BusinessData` and `TechnicianData` structs with role-based registration (`register_business`, `register_technician`), duplicate registration guard, and `get_user_data` view function for backend BCS deserialization

### Changed
- Standardized error codes for registration and identity verification.
- updated the registry to handle specific profile role data (Business and Technician)



