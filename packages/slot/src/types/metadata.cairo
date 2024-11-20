// Internal imports

use arcade_slot::helpers::json::{JsonifiableString, JsonifiableTrait};

// Constants

const COLOR_LENGTH: usize = 7;

#[derive(Clone, Drop)]
pub struct Metadata {
    color: felt252,
    name: ByteArray,
    description: ByteArray,
    image: ByteArray,
    banner: ByteArray,
}

// Implementations

pub impl MetadataJsonifiable of JsonifiableTrait<Metadata> {
    fn jsonify(self: Metadata) -> ByteArray {
        let mut color = "";
        color.append_word(self.color, COLOR_LENGTH);
        let mut string = "{";
        string += JsonifiableString::jsonify("color", format!("{}", color));
        string += "," + JsonifiableString::jsonify("name", format!("{}", self.name));
        string += "," + JsonifiableString::jsonify("description", format!("{}", self.description));
        string += "," + JsonifiableString::jsonify("image", format!("{}", self.image));
        string += "," + JsonifiableString::jsonify("banner", format!("{}", self.banner));
        string + "}"
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::{Metadata, JsonifiableTrait};

    #[test]
    fn test_metadata_jsonify() {
        let metadata = Metadata {
            color: '#123456',
            name: "name",
            description: "description",
            image: "image",
            banner: "banner",
        };
        let json = metadata.jsonify();
        assert_eq!(
            json,
            "{\"color\":\"#123456\",\"name\":\"name\",\"description\":\"description\",\"image\":\"image\",\"banner\":\"banner\"}"
        );
    }
}
