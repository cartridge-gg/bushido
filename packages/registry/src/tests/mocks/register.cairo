#[starknet::interface]
trait IRegister<TContractState> {
    fn register(
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
    fn update(
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
    fn publish(self: @TContractState, world_address: felt252, namespace: felt252);
    fn hide(self: @TContractState, world_address: felt252, namespace: felt252);
    fn whitelist(self: @TContractState, world_address: felt252, namespace: felt252);
    fn blacklist(self: @TContractState, world_address: felt252, namespace: felt252);
}

#[dojo::contract]
pub mod Register {
    // Starknet imports

    use starknet::{ContractAddress, get_block_timestamp, get_contract_address};

    // Dojo imports

    use dojo::world::WorldStorage;
    use dojo::contract::{IContractDispatcher, IContractDispatcherTrait};

    // Internal imports

    use registry::components::initializable::InitializableComponent;
    use registry::components::registerable::RegisterableComponent;

    // Local imports

    use super::IRegister;

    // Components

    component!(path: InitializableComponent, storage: initializable, event: InitializableEvent);
    impl InitializableImpl = InitializableComponent::InternalImpl<ContractState>;
    component!(path: RegisterableComponent, storage: registerable, event: RegisterableEvent);
    impl RegisterableImpl = RegisterableComponent::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub initializable: InitializableComponent::Storage,
        #[substorage(v0)]
        pub registerable: RegisterableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        InitializableEvent: InitializableComponent::Event,
        #[flat]
        RegisterableEvent: RegisterableComponent::Event
    }

    fn dojo_init(self: @ContractState, owner: felt252) {
        self.initializable.initialize(self.world_storage(), owner);
    }

    #[abi(embed_v0)]
    impl RegisterImpl of IRegister<ContractState> {
        fn register(
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
                );
        }

        fn update(
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
                );
        }

        fn publish(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registerable.publish(self.world_storage(), world_address, namespace);
        }

        fn hide(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registerable.hide(self.world_storage(), world_address, namespace);
        }

        fn whitelist(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registerable.whitelist(self.world_storage(), world_address, namespace);
        }

        fn blacklist(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registerable.blacklist(self.world_storage(), world_address, namespace);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@"namespace")
        }
    }
}
