// Interfaces

#[starknet::interface]
trait IRegistry<TContractState> {
    fn register_game(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        project: felt252,
        color: Option<felt252>,
        name: Option<ByteArray>,
        description: Option<ByteArray>,
        image: Option<ByteArray>,
        banner: Option<ByteArray>,
        discord: Option<ByteArray>,
        telegram: Option<ByteArray>,
        twitter: Option<ByteArray>,
        youtube: Option<ByteArray>,
        website: Option<ByteArray>,
    );
    fn update_game(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        color: Option<felt252>,
        name: Option<ByteArray>,
        description: Option<ByteArray>,
        image: Option<ByteArray>,
        banner: Option<ByteArray>,
        discord: Option<ByteArray>,
        telegram: Option<ByteArray>,
        twitter: Option<ByteArray>,
        youtube: Option<ByteArray>,
        website: Option<ByteArray>,
    );
    fn publish_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn hide_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn whitelist_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn blacklist_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn remove_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn register_achievement(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        identifier: felt252,
        karma: u16,
    );
    fn update_achievement(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        identifier: felt252,
        karma: u16,
    );
    fn publish_achievement(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
    fn hide_achievement(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
    fn whitelist_achievement(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
    fn blacklist_achievement(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
    fn remove_achievement(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
}

// Contracts

#[dojo::contract]
mod Registry {
    // Dojo imports

    use dojo::world::WorldStorage;

    // Component imports

    use registry::components::initializable::InitializableComponent;
    use registry::components::registerable::RegisterableComponent;
    use registry::components::trackable::TrackableComponent;

    // Internal imports

    use arcade::constants::NAMESPACE;

    // Local imports

    use super::IRegistry;

    // Components

    component!(path: InitializableComponent, storage: initializable, event: InitializableEvent);
    impl InitializableImpl = InitializableComponent::InternalImpl<ContractState>;
    component!(path: RegisterableComponent, storage: registerable, event: RegisterableEvent);
    impl RegisterableImpl = RegisterableComponent::InternalImpl<ContractState>;
    component!(path: TrackableComponent, storage: trackable, event: TrackableEvent);
    impl TrackableImpl = TrackableComponent::InternalImpl<ContractState>;

    // Storage

    #[storage]
    struct Storage {
        #[substorage(v0)]
        initializable: InitializableComponent::Storage,
        #[substorage(v0)]
        registerable: RegisterableComponent::Storage,
        #[substorage(v0)]
        trackable: TrackableComponent::Storage,
    }

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        InitializableEvent: InitializableComponent::Event,
        #[flat]
        RegisterableEvent: RegisterableComponent::Event,
        #[flat]
        TrackableEvent: TrackableComponent::Event,
    }

    // Constructor

    fn dojo_init(self: @ContractState, owner: felt252) {
        self.initializable.initialize(self.world_storage(), owner);
    }

    // Implementations

    #[abi(embed_v0)]
    impl RegistryImpl of IRegistry<ContractState> {
        fn register_game(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            project: felt252,
            color: Option<felt252>,
            name: Option<ByteArray>,
            description: Option<ByteArray>,
            image: Option<ByteArray>,
            banner: Option<ByteArray>,
            discord: Option<ByteArray>,
            telegram: Option<ByteArray>,
            twitter: Option<ByteArray>,
            youtube: Option<ByteArray>,
            website: Option<ByteArray>,
        ) {
            self
                .registerable
                .register(
                    self.world_storage(),
                    world_address,
                    namespace,
                    project,
                    color,
                    name,
                    description,
                    image,
                    banner,
                    discord,
                    telegram,
                    twitter,
                    youtube,
                    website,
                )
        }

        fn update_game(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            color: Option<felt252>,
            name: Option<ByteArray>,
            description: Option<ByteArray>,
            image: Option<ByteArray>,
            banner: Option<ByteArray>,
            discord: Option<ByteArray>,
            telegram: Option<ByteArray>,
            twitter: Option<ByteArray>,
            youtube: Option<ByteArray>,
            website: Option<ByteArray>,
        ) {
            self
                .registerable
                .update(
                    self.world_storage(),
                    world_address,
                    namespace,
                    color,
                    name,
                    description,
                    image,
                    banner,
                    discord,
                    telegram,
                    twitter,
                    youtube,
                    website,
                )
        }

        fn publish_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registerable.publish(self.world_storage(), world_address, namespace);
        }

        fn hide_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registerable.hide(self.world_storage(), world_address, namespace);
        }

        fn whitelist_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registerable.whitelist(self.world_storage(), world_address, namespace);
        }

        fn blacklist_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registerable.blacklist(self.world_storage(), world_address, namespace);
        }

        fn remove_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registerable.remove(self.world_storage(), world_address, namespace);
        }

        fn register_achievement(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
            karma: u16,
        ) {
            self
                .trackable
                .register(self.world_storage(), world_address, namespace, identifier, karma)
        }

        fn update_achievement(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
            karma: u16,
        ) {
            self.trackable.update(self.world_storage(), world_address, namespace, identifier, karma)
        }

        fn publish_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self.trackable.publish(self.world_storage(), world_address, namespace, identifier);
        }

        fn hide_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self.trackable.hide(self.world_storage(), world_address, namespace, identifier);
        }

        fn whitelist_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self.trackable.whitelist(self.world_storage(), world_address, namespace, identifier);
        }

        fn blacklist_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self.trackable.blacklist(self.world_storage(), world_address, namespace, identifier);
        }

        fn remove_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self.trackable.remove(self.world_storage(), world_address, namespace, identifier);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@NAMESPACE())
        }
    }
}
