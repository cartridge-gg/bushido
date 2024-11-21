#[starknet::component]
mod DeployableComponent {
    // Dojo imports

    use dojo::world::WorldStorage;

    // Internal imports

    use provider::store::{Store, StoreTrait};
    use provider::models::deployment::{Deployment, DeploymentTrait, DeploymentAssert};
    use provider::models::factory::{Factory, FactoryTrait, FactoryAssert};
    use provider::types::service::{Service, ServiceTrait, SERVICE_COUNT};
    use provider::types::status::Status;
    use provider::types::tier::Tier;

    // Storage

    #[storage]
    struct Storage {}

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    #[generate_trait]
    impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn initialize(self: @ComponentState<TContractState>, world: WorldStorage,) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);
            // [Effect] Create every service factories
            let mut index = SERVICE_COUNT;
            while index > 0 {
                let service: Service = index.into();
                let version = service.version();
                let factory = FactoryTrait::new(service, version, version);
                store.set_factory(@factory);
                index -= 1;
            }
        }

        fn deploy(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            service: Service,
            project: felt252,
            tier: Tier,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Factory exists
            let factory = store.get_factory(service.into());
            factory.assert_does_exist();

            // [Check] Deployment does not exist
            let deployment = store.get_deployment(service.into(), project);
            deployment.assert_does_not_exist();

            // [Effect] Create deployment
            let owner = starknet::get_caller_address().into();
            let deployment = DeploymentTrait::new(
                service: service, project: project, owner: owner, tier: tier, config: "",
            );
            store.set_deployment(@deployment);
        }

        fn remove(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            service: Service,
            project: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Factory exists
            let factory = store.get_factory(service.into());
            factory.assert_does_exist();

            // [Check] Deployment exists
            let mut deployment = store.get_deployment(service.into(), project);
            deployment.assert_does_exist();

            // [Check] Caller is owner
            deployment.assert_is_owner(starknet::get_caller_address().into());

            // [Effect] Delete deployment
            deployment.nullify();
            store.delete_deployment(@deployment);
        }
    }
}
