#[derive(Copy, Drop, PartialEq)]
pub enum Role {
    None,
    Member,
    Admin,
    Owner,
}

// Implementations

impl IntoRoleU8 of core::Into<Role, u8> {
    #[inline]
    fn into(self: Role) -> u8 {
        match self {
            Role::None => 0,
            Role::Member => 1,
            Role::Admin => 2,
            Role::Owner => 3,
        }
    }
}

impl IntoU8Role of core::Into<u8, Role> {
    #[inline]
    fn into(self: u8) -> Role {
        match self {
            0 => Role::None,
            1 => Role::Member,
            2 => Role::Admin,
            3 => Role::Owner,
            _ => Role::None,
        }
    }
}
