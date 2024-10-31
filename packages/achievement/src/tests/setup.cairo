mod setup {
    // Core imports

    use core::debug::PrintTrait;

    // Starknet imports

    use starknet::ContractAddress;
    use starknet::testing;
    use starknet::testing::{set_contract_address, set_block_timestamp};

    // Dojo imports

    use dojo::world::{WorldStorage, WorldStorageTrait};
    use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource, ContractDefTrait};

    // Internal imports

    use achievement::models::{index as models};
    use achievement::events::{index as events};
    use achievement::tests::mocks::achiever::{Achiever, IAchiever, IAchieverDispatcher};
    use achievement::tests::mocks::controller::{Controller, IController, IControllerDispatcher};
    use achievement::tests::mocks::registrer::{Registrer, IRegistrer, IRegistrerDispatcher};

    // Constant

    fn OWNER() -> ContractAddress {
        starknet::contract_address_const::<'OWNER'>()
    }

    fn PLAYER() -> ContractAddress {
        starknet::contract_address_const::<'PLAYER'>()
    }

    #[derive(Copy, Drop)]
    struct Systems {
        achiever: IAchieverDispatcher,
        controller: IControllerDispatcher,
        registrer: IRegistrerDispatcher,
    }

    #[derive(Copy, Drop)]
    struct Context {
        player_id: felt252,
    }

    /// Drop all events from the given contract address
    pub fn clear_events(address: ContractAddress) {
        loop {
            match starknet::testing::pop_log_raw(address) {
                core::option::Option::Some(_) => {},
                core::option::Option::None => { break; },
            };
        }
    }

    #[inline]
    fn setup_namespace() -> NamespaceDef {
        NamespaceDef {
            namespace: "namespace", resources: [
                TestResource::Model(models::m_Game::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Model(models::m_Achievement::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Event(events::e_Trophy::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Event(events::e_Progress::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Contract(
                    ContractDefTrait::new(Achiever::TEST_CLASS_HASH, "Achiever")
                        .with_writer_of([dojo::utils::bytearray_hash(@"namespace")].span())
                ),
                TestResource::Contract(
                    ContractDefTrait::new(Controller::TEST_CLASS_HASH, "Controller")
                        .with_writer_of([dojo::utils::bytearray_hash(@"namespace")].span())
                ),
                TestResource::Contract(
                    ContractDefTrait::new(Registrer::TEST_CLASS_HASH, "Registrer")
                        .with_writer_of([dojo::utils::bytearray_hash(@"namespace")].span())
                ),
            ].span()
        }
    }

    #[inline]
    fn spawn_game() -> (WorldStorage, Systems, Context) {
        // [Setup] World
        set_contract_address(OWNER());
        let namespace_def = setup_namespace();
        let world = spawn_test_world([namespace_def].span());
        // [Setup] Systems
        let (achiever_address, _) = world.dns(@"Achiever").unwrap();
        let (controller_address, _) = world.dns(@"Controller").unwrap();
        let (registrer_address, _) = world.dns(@"Registrer").unwrap();
        let systems = Systems {
            achiever: IAchieverDispatcher { contract_address: achiever_address },
            controller: IControllerDispatcher { contract_address: controller_address },
            registrer: IRegistrerDispatcher { contract_address: registrer_address },
        };

        // [Setup] Context
        let context = Context { player_id: PLAYER().into() };

        // [Return]
        (world, systems, context)
    }
}
