//
//  DataStructs.swift
//  
//
//  Created by Vincent Kwok on 7/6/22.
//
//  Structs here are internal to this package
//  and not meant for external use

import Foundation
import DiscordKitCommon

/// Connection properties used to construct client info that is sent
/// in the ``GatewayIdentify`` payload
struct GatewayConnProperties: OutgoingGatewayData {
    /// OS the client is running on
    ///
    /// Always `Mac OS X`
    let os: String

    /// Browser name
    ///
    /// Observed values were `Chrome` when running on Google Chrome and
    /// `Discord Client` when running in the desktop client.
    ///
    /// > For now, this value is hardcoded to `Discord Client` in the
    /// > ``DiscordAPI/getSuperProperties()`` method. Customisability
    /// > might be added in a future release.
    let browser: String

    /// Release channel of target official client
    ///
    /// Refer to ``GatewayConfig/clientParity`` for more details.
    let release_channel: String?

    /// Version of target official client
    ///
    /// Refer to ``GatewayConfig/clientParity`` for more details.
    let client_version: String?

    /// OS version
    ///
    /// The version of the OS the client is running on. This is dynamically
    /// retrieved in ``DiscordAPI/getSuperProperties()`` by calling `uname()`.
    /// For macOS, it is the version of the Darwin Kernel, which is `21.4.0`
    /// as of macOS `12.3`.
    let os_version: String?

    /// Machine arch
    ///
    /// The arch of the machine the client is running on. This is dynamically
    /// retrieved in ``DiscordAPI/getSuperProperties()`` by calling `uname()`.
    /// For macOS, it could be either `x86_64` (Intel) or `arm64` (Apple Silicon).
    let os_arch: String?

    /// System locale
    ///
    /// The locale (language) of the system. This is hardcoded to be `en-US` for now.
    let system_locale: String?

    /// Build number of target official client
    ///
    /// Refer to ``GatewayConfig/clientParity`` for more details.
    let client_build_number: Int?
}

/// Current client state, sent with the ``GatewayIdentify`` payload
///
/// > Warning: This should only be sent in identify payloads for user accounts. Bot accounts don't need this!
struct ClientState: OutgoingGatewayData {
    let guild_hashes: GuildHashes
    let highest_last_message_id: Snowflake
    let read_state_version: Int
    let user_guild_settings_version: Int
    let user_settings_version: Int
}
/// Placeholder struct for `guild_hashes` in `client_state`
///
/// This is currently empty, and simply serves as a placeholder.
struct GuildHashes: OutgoingGatewayData {

}

/// Gateway Heartbeat
///
/// Sent when establishing a new session with the Gateway, to identify the client.
/// Refer to ``GatewayHello/heartbeat_interval`` for more details regarding
/// the heartbeat timings.
///
/// > Outgoing Gateway data struct for opcode 2
struct GatewayHeartbeat: OutgoingGatewayData {
    let seq: Int?

    init(_ seq: Int?) { self.seq = seq }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(seq)
    }
}

/// Gateway Identify
///
/// Sent every ``GatewayHello/heartbeat_interval``, to prevent the Gateway
/// from closing the connection and
///
/// > Outgoing Gateway data struct for opcode 1
struct GatewayIdentify: OutgoingGatewayData {
    let token: String
    let properties: GatewayConnProperties
    let compress: Bool?
    let large_threshold: Int? // Value between 50 and 250, total number of members where the gateway will stop sending offline members in the guild member list
    let shard: [Int]? // Array of two integers (shard_id, num_shards)
    let presence: GatewayPresenceUpdate?
    let client_state: ClientState?
    let capabilities: Int
}

/// Gateway Resume
///
/// Sent when attempting to resume a broken websocket connection.
///
/// > Outgoing Gateway data struct for opcode 6
public struct GatewayResume: OutgoingGatewayData {
    public let token: String
    public let session_id: String
    @NullEncodable public var seq: Int? // Last sequence number received
}
