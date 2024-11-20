// Internal imports

use arcade_slot::helpers::json::{JsonifiableString, JsonifiableTrait};

#[derive(Clone, Drop)]
pub struct Socials {
    discord: ByteArray,
    telegram: ByteArray,
    twitter: ByteArray,
    youtube: ByteArray,
    website: ByteArray,
}

// Implementations

pub impl SocialsJsonifiable of JsonifiableTrait<Socials> {
    fn jsonify(self: Socials) -> ByteArray {
        let mut string = "{";
        string += JsonifiableString::jsonify("discord", format!("{}", self.discord));
        string += "," + JsonifiableString::jsonify("telegram", format!("{}", self.telegram));
        string += "," + JsonifiableString::jsonify("twitter", format!("{}", self.twitter));
        string += "," + JsonifiableString::jsonify("youtube", format!("{}", self.youtube));
        string += "," + JsonifiableString::jsonify("website", format!("{}", self.website));
        string + "}"
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::{Socials, JsonifiableTrait};

    #[test]
    fn test_socials_jsonify() {
        let socials = Socials {
            discord: "discord",
            telegram: "telegram",
            twitter: "twitter",
            youtube: "youtube",
            website: "website",
        };
        let json = socials.jsonify();
        assert_eq!(
            json,
            "{\"discord\":\"discord\",\"telegram\":\"telegram\",\"twitter\":\"twitter\",\"youtube\":\"youtube\",\"website\":\"website\"}"
        );
    }
}
