//! Cryptography helper functions

use std::path::{Path, PathBuf};

use anyhow::Context;

/// Get the default path for the agent's private key
pub fn get_default_key_path() -> PathBuf {
    directories::BaseDirs::new()
        .unwrap()
        .home_dir()
        .join(".config/ewpratten/config-agent-key")
}

/// If a key does not exist, generate a new one
fn make_key_if_not_exists(private_key_path: &Path) {
    log::debug!("Ensuring keypair exists as {:?}", private_key_path);
    if !private_key_path.exists() {
        // Generate a new ed25519 keypair
        log::info!("Generating a new ed25519 keypair for this system");
        let private_key =
            ssh_key::PrivateKey::random(&mut rand::rngs::OsRng, ssh_key::Algorithm::Ed25519)
                .unwrap();
        let public_key = private_key.public_key();

        // Make sure the parent directory exists
        std::fs::create_dir_all(private_key_path.parent().unwrap())
            .with_context(|| "Failed to create keypair directory structure")
            .unwrap();

        // Write the private key to disk
        std::fs::write(
            &private_key_path,
            private_key
                .to_openssh(ssh_key::LineEnding::default())
                .unwrap(),
        )
        .with_context(|| "Failed to write private key to disk")
        .unwrap();

        // Write the public key to disk
        std::fs::write(
            &private_key_path.with_extension("pub"),
            public_key.to_openssh().unwrap(),
        )
        .with_context(|| "Failed to write public key to disk")
        .unwrap();
    }
}

/// Get the public key for this agent
pub fn get_public_key(private_key_path: &Path) -> ssh_key::PublicKey {
    make_key_if_not_exists(private_key_path);
    std::fs::read_to_string(&private_key_path.with_extension("pub"))
        .unwrap()
        .parse::<ssh_key::PublicKey>()
        .unwrap()
}
