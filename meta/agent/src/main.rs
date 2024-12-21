mod crypto;

use std::path::PathBuf;

use clap::Parser;

/// Evan's configuration agent
#[derive(Parser, Debug)]
#[command(version, about, long_about)]
struct Args {
    #[clap(subcommand)]
    command: Command,

    /// Enable verbose logging
    #[clap(short, long)]
    verbose: bool,
}

/// CLI commands
#[derive(Parser, Debug)]
enum Command {
    /// Check for any updates
    Check {
        /// Use a custom endpoint
        endpoint: Option<String>,

        /// Use a custom private key file
        private_key: Option<PathBuf>,
    },

    /// Print this machine's public key
    #[clap(alias = "pubkey")]
    PublicKey,

    /// Refresh the system
    Refresh {
        /// Use a custom endpoint
        endpoint: Option<String>,

        /// Use a custom private key file
        private_key: Option<PathBuf>,
    },
}

pub fn main() {
    // Parse the command line arguments
    let args: Args = Args::parse();

    // Handle commands
    match args.command {
        Command::Check { .. } => todo!(),
        Command::PublicKey => {
            let key_path = crypto::get_default_key_path();
            let public_key = crypto::get_public_key(&key_path);
            println!("{}", public_key.to_openssh().unwrap());
        }
        Command::Refresh { .. } => todo!(),
    }
}
