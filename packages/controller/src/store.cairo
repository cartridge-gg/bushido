//! Store struct and component management methods.

// Starknet imports

use starknet::SyscallResultTrait;

// Dojo imports

use dojo::world::WorldStorage;
use dojo::model::ModelStorage;

// Models imports

use controller::models::account::Account;
use controller::models::controller::Controller;
use controller::models::signer::Signer;


// Structs

#[derive(Copy, Drop)]
struct Store {
    world: WorldStorage,
}

// Implementations

#[generate_trait]
impl StoreImpl of StoreTrait {
    #[inline]
    fn new(world: WorldStorage) -> Store {
        Store { world: world }
    }

    #[inline]
    fn get_account(self: Store, account_id: felt252) -> Account {
        self.world.read_model(account_id)
    }

    #[inline]
    fn get_controller(self: Store, controller_id: felt252) -> Controller {
        self.world.read_model(controller_id)
    }

    #[inline]
    fn get_signer(self: Store, signer_id: felt252) -> Signer {
        self.world.read_model(signer_id)
    }

    #[inline]
    fn set_account(ref self: Store, account: @Account) {
        self.world.write_model(account);
    }

    #[inline]
    fn set_controller(ref self: Store, controller: @Controller) {
        self.world.write_model(controller);
    }
}
