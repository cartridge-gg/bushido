// Intenral imports

use controller::models::index::Member;
use controller::types::role::Role;

// Errors

pub mod errors {
    pub const MEMBER_ALREADY_EXISTS: felt252 = 'Member: already exists';
    pub const MEMBER_NOT_EXIST: felt252 = 'Member: does not exist';
    pub const MEMBER_INVALID_ACCOUNT_ID: felt252 = 'Member: invalid account id';
    pub const MEMBER_INVALID_TEAM_ID: felt252 = 'Member: invalid team id';
    pub const MEMBER_INVALID_ROLE: felt252 = 'Member: invalid role';
}

#[generate_trait]
impl MemberImpl of MemberTrait {
    #[inline]
    fn new(account_id: felt252, team_id: felt252, role: Role) -> Member {
        // [Check] Inputs
        MemberAssert::assert_valid_account_id(account_id);
        MemberAssert::assert_valid_team_id(team_id);
        MemberAssert::assert_valid_role(role);
        // [Return] Member
        Member { account_id: account_id, team_id: team_id, role: role.into() }
    }
}

#[generate_trait]
impl MemberAssert of AssertTrait {
    #[inline]
    fn assert_does_not_exist(self: @Member) {
        assert(self.role == @Role::None.into(), errors::MEMBER_ALREADY_EXISTS);
    }

    #[inline]
    fn assert_does_exist(self: @Member) {
        assert(self.role != @Role::None.into(), errors::MEMBER_NOT_EXIST);
    }

    #[inline]
    fn assert_valid_account_id(account_id: felt252) {
        assert(account_id != 0, errors::MEMBER_INVALID_ACCOUNT_ID);
    }

    #[inline]
    fn assert_valid_team_id(team_id: felt252) {
        assert(team_id != 0, errors::MEMBER_INVALID_TEAM_ID);
    }

    #[inline]
    fn assert_valid_role(role: Role) {
        assert(role != Role::None, errors::MEMBER_INVALID_ROLE);
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::{Member, MemberTrait, MemberAssert, Role};

    // Constants

    const ACCOUNT_ID: felt252 = 'ACCOUNT_ID';
    const TEAM_ID: felt252 = 'TEAM_ID';
    const ROLE: Role = Role::Admin;

    #[test]
    fn test_deployment_new() {
        let member = MemberTrait::new(ACCOUNT_ID, TEAM_ID, ROLE);
        assert_eq!(member.account_id, ACCOUNT_ID);
        assert_eq!(member.team_id, TEAM_ID);
        assert_eq!(member.role, ROLE.into());
    }

    #[test]
    fn test_deployment_assert_does_exist() {
        let member = MemberTrait::new(ACCOUNT_ID, TEAM_ID, ROLE);
        member.assert_does_exist();
    }

    #[test]
    #[should_panic(expected: 'Member: already exists')]
    fn test_deployment_revert_already_exists() {
        let member = MemberTrait::new(ACCOUNT_ID, TEAM_ID, ROLE);
        member.assert_does_not_exist();
    }

    #[test]
    #[should_panic(expected: 'Member: invalid role')]
    fn test_deployment_revert_invalid_role() {
        MemberTrait::new(ACCOUNT_ID, TEAM_ID, Role::None);
    }
}
