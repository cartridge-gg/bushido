// Internal imports

use registry::helpers::json::{JsonifiableString, JsonifiableTrait};

#[derive(Clone, Drop)]
pub struct Socials {
    discord: ByteArray,
    telegram: ByteArray,
    twitter: ByteArray,
    youtube: ByteArray,
    website: ByteArray,
}

// Implementations

#[generate_trait]
pub impl SocialsImpl of SocialsTrait {
    fn new(
        discord: Option<ByteArray>,
        telegram: Option<ByteArray>,
        twitter: Option<ByteArray>,
        youtube: Option<ByteArray>,
        website: Option<ByteArray>
    ) -> Socials {
        let discord = match discord {
            Option::Some(discord) => discord,
            Option::None => "",
        };
        let telegram = match telegram {
            Option::Some(telegram) => telegram,
            Option::None => "",
        };
        let twitter = match twitter {
            Option::Some(twitter) => twitter,
            Option::None => "",
        };
        let youtube = match youtube {
            Option::Some(youtube) => youtube,
            Option::None => "",
        };
        let website = match website {
            Option::Some(website) => website,
            Option::None => "",
        };
        Socials {
            discord: discord,
            telegram: telegram,
            twitter: twitter,
            youtube: youtube,
            website: website
        }
    }
}

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

pub impl SocialsDefault of core::Default<Socials> {
    fn default() -> Socials {
        SocialsTrait::new(Option::None, Option::None, Option::None, Option::None, Option::None)
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
