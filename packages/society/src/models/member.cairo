// Intenral imports

use society::models::index::Member;
use society::types::role::Role;

// Errors

pub mod errors {
    pub const MEMBER_ALREADY_EXISTS: felt252 = 'Member: already exists';
    pub const MEMBER_NOT_EXIST: felt252 = 'Member: does not exist';
    pub const MEMBER_INVALID_ACCOUNT_ID: felt252 = 'Member: invalid account id';
    pub const MEMBER_ALREADY_HIRED: felt252 = 'Member: already hired';
}

#[generate_trait]
impl MemberImpl of MemberTrait {
    #[inline]
    fn new(account_id: felt252) -> Member {
        // [Check] Inputs
        MemberAssert::assert_valid_account_id(account_id);
        // [Return] Member
        let role = Role::None;
        Member { id: account_id, role: role.into(), guild_id: 0, request_count: 0 }
    }

    #[inline]
    fn hire(ref self: Member, guild_id: u32) {
        // [Check] Member can be hired
        self.assert_is_hireable();
        // [Update] Member
        self.guild_id = guild_id;
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
    fn assert_is_hireable(self: @Member) {
        assert(self.guild_id == @0, errors::MEMBER_ALREADY_HIRED);
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::{Member, MemberTrait, MemberAssert, Role};

    // Constants

    const ACCOUNT_ID: felt252 = 'ACCOUNT_ID';
    const GUILD_ID: u32 = 42;

    #[test]
    fn test_deployment_new() {
        let member = MemberTrait::new(ACCOUNT_ID);
        assert_eq!(member.id, ACCOUNT_ID);
        assert_eq!(member.guild_id, 0);
        assert_eq!(member.role, Role::None.into());
    }
}
