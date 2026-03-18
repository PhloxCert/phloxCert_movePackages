module register_contract::LocalRegistry {
    use iota::table::{Self, Table};
    use iota::tx_context::{TxContext};
    use std::string::{String};

    // roles
    const ROLE_LOCAL_BUSINESS: u8 = 1;
    const ROLE_AUTHORIZED_TECHNICIAN: u8 = 2;

    const EUserAlreadyRegistered: u64 = 1;

    public struct BusinessData has store, copy, drop {
        address: String,
        vat_number: String,
    }

    public struct TechnicianData has store, copy, drop {
        license_number: String,
        specialization: String,
    }

    public struct User has store, copy, drop {
        role: u8,
        name: String,

        business_info: std::option::Option<BusinessData>,
        technician_info: std::option::Option<TechnicianData>,
    }

    public struct Registry has key {
        id: UID,
        users: Table<address, User>,
    }

    fun init(ctx: &mut TxContext) {
        let registry = Registry {
            id: object::new(ctx),
            users: table::new(ctx),
        };
        iota::transfer::share_object(registry);
    }

    public fun register_business(
        registry: &mut Registry,
        name: String,
        address: String,
        vat: String,
        ctx: &mut TxContext
    ) {
        let sender = iota::tx_context::sender(ctx);
        assert!(!table::contains(&registry.users, sender), EUserAlreadyRegistered);

        let business_info = BusinessData { address, vat_number: vat};
        let user = User {
            role: ROLE_LOCAL_BUSINESS,
            name,
            business_info: std::option::some(business_info),
            technician_info: std::option::none(),
        };
        table::add(&mut registry.users, sender, user);
    }

    public fun register_technician(
        registry: &mut Registry,
        name: String,
        license: String,
        spec: String,
        ctx: &mut TxContext
    ) {
        let sender = iota::tx_context::sender(ctx);
        assert!(!table::contains(&registry.users, sender), EUserAlreadyRegistered);

        let technician_info = TechnicianData { license_number: license, specialization: spec };
        let user = User {
            role: ROLE_AUTHORIZED_TECHNICIAN,
            name,
            business_info: std::option::none(),
            technician_info: std::option::some(technician_info),
        };
        table::add(&mut registry.users, sender, user);
    }
    public fun get_user_data(registry: &Registry, user_address: address): &User {
        assert!(table::contains(&registry.users, user_address), 0); 
        table::borrow(&registry.users, user_address)
    }
}