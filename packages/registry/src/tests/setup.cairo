mod setup {
    // Core imports

    use core::debug::PrintTrait;

    // Starknet imports

    use starknet::ContractAddress;
    use starknet::testing;
    use starknet::testing::{set_caller_address, set_contract_address, set_block_timestamp};

    // Dojo imports

    use dojo::world::{WorldStorage, WorldStorageTrait};
    use dojo_cairo_test::{
        spawn_test_world, NamespaceDef, ContractDef, TestResource, ContractDefTrait,
        WorldStorageTestTrait
    };

    // Internal imports

    use registry::models::{index as models};
    use registry::tests::mocks::register::{Register, IRegister, IRegisterDispatcher};
    use registry::tests::mocks::tracker::{Tracker, ITracker, ITrackerDispatcher};

    // Constant

    fn OWNER() -> ContractAddress {
        starknet::contract_address_const::<'OWNER'>()
    }

    fn PLAYER() -> ContractAddress {
        starknet::contract_address_const::<'PLAYER'>()
    }

    #[derive(Copy, Drop)]
    struct Systems {
        register: IRegisterDispatcher,
        tracker: ITrackerDispatcher,
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
                TestResource::Model(models::m_Access::TEST_CLASS_HASH),
                TestResource::Model(models::m_Achievement::TEST_CLASS_HASH),
                TestResource::Model(models::m_Game::TEST_CLASS_HASH),
                TestResource::Contract(Register::TEST_CLASS_HASH),
                TestResource::Contract(Tracker::TEST_CLASS_HASH),
            ].span()
        }
    }

    fn setup_contracts() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"namespace", @"Register")
                .with_writer_of([dojo::utils::bytearray_hash(@"namespace")].span())
                .with_init_calldata(array![OWNER().into()].span()),
            ContractDefTrait::new(@"namespace", @"Tracker")
                .with_writer_of([dojo::utils::bytearray_hash(@"namespace")].span())
                .with_init_calldata(array![OWNER().into()].span()),
        ].span()
    }

    #[inline]
    fn spawn() -> (WorldStorage, Systems, Context) {
        // [Setup] World
        set_contract_address(OWNER());
        let namespace_def = setup_namespace();
        let world = spawn_test_world([namespace_def].span());
        world.sync_perms_and_inits(setup_contracts());
        // [Setup] Systems
        let (register_address, _) = world.dns(@"Register").unwrap();
        let (tracker_address, _) = world.dns(@"Tracker").unwrap();
        let systems = Systems {
            register: IRegisterDispatcher { contract_address: register_address },
            tracker: ITrackerDispatcher { contract_address: tracker_address },
        };

        // [Setup] Context
        let context = Context { player_id: PLAYER().into() };

        // [Return]
        (world, systems, context)
    }
}
