// Internal imports

use provider::elements::services;

// Constants

pub const SERVICE_COUNT: u8 = 3;

#[derive(Copy, Drop, PartialEq)]
pub enum Service {
    None,
    Katana,
    Torii,
    Saya,
}

// Implementations

#[generate_trait]
impl ServiceImpl of ServiceTrait {
    fn version(self: Service) -> felt252 {
        match self {
            Service::None => 0,
            Service::Katana => services::katana::Katana::version(),
            Service::Torii => services::torii::Torii::version(),
            Service::Saya => services::saya::Saya::version(),
        }
    }
}

impl IntoServiceU8 of core::Into<Service, u8> {
    #[inline]
    fn into(self: Service) -> u8 {
        match self {
            Service::None => 0,
            Service::Katana => 1,
            Service::Torii => 2,
            Service::Saya => 3,
        }
    }
}

impl IntoU8Service of core::Into<u8, Service> {
    #[inline]
    fn into(self: u8) -> Service {
        match self {
            0 => Service::None,
            1 => Service::Katana,
            2 => Service::Torii,
            3 => Service::Saya,
            _ => Service::None,
        }
    }
}
