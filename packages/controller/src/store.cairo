//! Store struct and component management methods.

// Starknet imports

use starknet::SyscallResultTrait;

// Dojo imports

use dojo::world::WorldStorage;
use dojo::model::ModelStorage;

// Models imports

use controller::models::account::Account;
use controller::models::controller::Controller;
use controller::models::member::Member;
use controller::models::signer::Signer;
use controller::models::team::Team;


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
    fn get_member(self: Store, account_id: felt252, team_id: felt252) -> Member {
        self.world.read_model((account_id, team_id))
    }

    #[inline]
    fn get_signer(self: Store, signer_id: felt252) -> Signer {
        self.world.read_model(signer_id)
    }

    #[inline]
    fn get_team(self: Store, team_id: felt252) -> Team {
        self.world.read_model(team_id)
    }

    #[inline]
    fn set_account(ref self: Store, account: @Account) {
        self.world.write_model(account);
    }

    #[inline]
    fn set_controller(ref self: Store, controller: @Controller) {
        self.world.write_model(controller);
    }

    #[inline]
    fn set_member(ref self: Store, member: @Member) {
        self.world.write_model(member);
    }

    #[inline]
    fn set_team(ref self: Store, team: @Team) {
        self.world.write_model(team);
    }
}
