// Intenral imports

use arcade_slot::models::index::Service;

// Errors

pub mod errors {
    pub const SERVICE_ALREADY_EXISTS: felt252 = 'Service: already exists';
    pub const SERVICE_NOT_EXIST: felt252 = 'Service: does not exist';
    pub const SERVICE_INVALID_IDENTIFIER: felt252 = 'Service: invalid identifier';
    pub const SERVICE_INVALID_VERSION: felt252 = 'Service: invalid version';
}

#[generate_trait]
impl ServiceImpl of ServiceTrait {
    #[inline]
    fn new(id: felt252, version: felt252, default_version: felt252,) -> Service {
        // [Check] Inputs
        ServiceAssert::assert_valid_identifier(id);
        ServiceAssert::assert_valid_version(version);
        ServiceAssert::assert_valid_version(default_version);
        // [Return] Service
        Service { id: id, version: version, default_version: default_version, }
    }
}

#[generate_trait]
impl ServiceAssert of AssertTrait {
    #[inline]
    fn assert_does_not_exist(self: Service) {
        assert(self.version == 0, errors::SERVICE_ALREADY_EXISTS);
    }

    #[inline]
    fn assert_does_exist(self: Service) {
        assert(self.version != 0, errors::SERVICE_NOT_EXIST);
    }

    #[inline]
    fn assert_valid_identifier(identifier: felt252) {
        assert(identifier != 0, errors::SERVICE_INVALID_IDENTIFIER);
    }

    #[inline]
    fn assert_valid_version(version: felt252) {
        assert(version != 0, errors::SERVICE_INVALID_VERSION);
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::{Service, ServiceTrait, ServiceAssert};

    // Constants

    const IDENTIFIER: felt252 = 'ID';
    const VERSION: felt252 = 'VERSION';
    const DEFAULT_VERSION: felt252 = 'DEFAULT';

    #[test]
    fn test_service_new() {
        let service = ServiceTrait::new(IDENTIFIER, VERSION, DEFAULT_VERSION);
        assert_eq!(service.id, IDENTIFIER);
        assert_eq!(service.version, VERSION);
        assert_eq!(service.default_version, DEFAULT_VERSION);
    }

    #[test]
    fn test_service_assert_does_exist() {
        let service = ServiceTrait::new(IDENTIFIER, VERSION, DEFAULT_VERSION);
        service.assert_does_exist();
    }

    #[test]
    #[should_panic(expected: 'Service: already exists')]
    fn test_service_revert_already_exists() {
        let service = ServiceTrait::new(IDENTIFIER, VERSION, DEFAULT_VERSION);
        service.assert_does_not_exist();
    }
}
