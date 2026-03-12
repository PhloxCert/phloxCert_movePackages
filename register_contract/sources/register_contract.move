module register_contract::LocalRegistry {
    // Table si trova nel framework Iota, non in std
    use iota::table::{Self, Table};
    use iota::tx_context::{Self, TxContext}; // Necessario per creare ID
    use iota::transfer;
    
    // ma se vuoi essere esplicito, importa solo ciò che ti serve senza Self
    use std::option::Option;

    public struct User has store, copy, drop {
        role: u8,       
        name: vector<u8>,
    }

    // Aggiunta l'abilità 'key' e l'ID per renderlo un oggetto Iota
    public struct Registry has key, store {
        id: UID, 
        users: Table<vector<u8>, User>, 
    }

    // Questa funzione viene eseguita UNA SOLA VOLTA al momento del publish
    fun init(ctx: &mut TxContext) {
        let registry = Registry {
            id: object::new(ctx),
            users: table::new(ctx),
        };
        // Rendiamo il Registry un "Shared Object" così chiunque può leggerlo
        transfer::share_object(registry);
    }
    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(ctx)
    }

    public fun add_user(registry: &mut Registry, address: vector<u8>, name: vector<u8>, role: u8) {
        table::add(&mut registry.users, address, User { role, name });
    }

    public fun get_user(registry: &Registry, address: vector<u8>): Option<User> {
        if (table::contains(&registry.users, address)) {
            // Option::some è disponibile implicitamente o tramite std::option
            std::option::some(*table::borrow(&registry.users, address))
        } else {
            std::option::none()
        }
    }
}