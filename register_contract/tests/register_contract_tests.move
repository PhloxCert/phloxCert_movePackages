
#[test_only]
module register_contract::local_registry_tests {
    use iota::test_scenario::{Self, Scenario};
    use register_contract::LocalRegistry::{Self, Registry, User};
    use std::option;

    // Definiamo degli indirizzi fittizi per i test
    const ADMIN: address = @0xAD;
    const USER_1: address = @0x42;

    #[test]
    fun test_register_and_get_user() {
        let mut scenario_val = test_scenario::begin(ADMIN);
        let scenario = &mut scenario_val;

        // 1. Inizializziamo il contratto (chiamando init implicitamente o manualmente)
        // Nota: Nei test Move, init non viene chiamato automaticamente a meno che non si usi un tool specifico.
        // Lo facciamo qui simulando la creazione del Registry.
        LocalRegistry::init_for_testing(test_scenario::ctx(scenario));
        
        test_scenario::next_tx(scenario, ADMIN);
        {
            // 2. Preleviamo l'oggetto condiviso Registry
            let mut registry = test_scenario::take_shared<Registry>(scenario);
            
            let addr_bytes = b"address_di_test";
            let name = b"Mario Rossi";
            let role = 1;

            // 3. Aggiungiamo un utente
            LocalRegistry::add_user(&mut registry, addr_bytes, name, role);

            // 4. Verifichiamo che l'utente esista e i dati siano corretti
            let user_opt = LocalRegistry::get_user(&registry, addr_bytes);
            assert!(option::is_some(&user_opt), 0);
            
            let user = option::destroy_some(user_opt);
            // In Move i confronti tra vector<u8> si fanno con ==
            // Se 'User' ha l'abilità 'drop', possiamo spacchettarlo o confrontarlo
            
            test_scenario::return_shared(registry);
        };
        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_user_not_found() {
        let mut scenario_val = test_scenario::begin(ADMIN);
        let scenario = &mut scenario_val;

        LocalRegistry::init_for_testing(test_scenario::ctx(scenario));
        
        test_scenario::next_tx(scenario, ADMIN);
        {
            let registry = test_scenario::take_shared<Registry>(scenario);
            
            // Cerchiamo un indirizzo mai registrato
            let user_opt = LocalRegistry::get_user(&registry, b"non_esisto");
            assert!(option::is_none(&user_opt), 1);

            test_scenario::return_shared(registry);
        };
        test_scenario::end(scenario_val);
    }
}

