// Internal imports

use achievement::types::task::Task;

#[starknet::interface]
trait IAchiever<TContractState> {
    fn create(
        self: @TContractState,
        id: felt252,
        hidden: bool,
        index: u8,
        points: u16,
        group: felt252,
        icon: felt252,
        title: felt252,
        description: ByteArray,
        tasks: Span<Task>,
        data: ByteArray,
    );
    fn update(self: @TContractState, player_id: felt252, task_id: felt252, count: u32,);
}

#[dojo::contract]
pub mod Achiever {
    // Starknet imports

    use starknet::{ContractAddress, get_block_timestamp, get_contract_address};

    // Dojo imports

    use dojo::world::WorldStorage;
    use dojo::contract::{IContractDispatcher, IContractDispatcherTrait};

    // Internal imports

    use achievement::types::task::Task;
    use achievement::components::achievable::AchievableComponent;

    // Local imports

    use super::IAchiever;

    // Components

    component!(path: AchievableComponent, storage: achievable, event: AchievableEvent);
    impl InternalImpl = AchievableComponent::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub achievable: AchievableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        AchievableEvent: AchievableComponent::Event
    }

    #[abi(embed_v0)]
    impl AchieverImpl of IAchiever<ContractState> {
        fn create(
            self: @ContractState,
            id: felt252,
            hidden: bool,
            index: u8,
            points: u16,
            group: felt252,
            icon: felt252,
            title: felt252,
            description: ByteArray,
            tasks: Span<Task>,
            data: ByteArray,
        ) {
            self
                .achievable
                .create(
                    self.world_storage(),
                    id,
                    hidden,
                    index,
                    points,
                    group,
                    icon,
                    title,
                    description,
                    tasks,
                    data
                );
        }

        fn update(self: @ContractState, player_id: felt252, task_id: felt252, count: u32,) {
            self.achievable.update(self.world_storage(), player_id, task_id, count);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@"namespace")
        }
    }
}
