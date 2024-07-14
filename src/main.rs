use anyhow::Result;
use lapce_plugin::{
    psp_types::{
        lsp_types::{request::Initialize, DocumentFilter, DocumentSelector, InitializeParams, Url},
        Request,
    },
    register_plugin, Http, LapcePlugin, VoltEnvironment, PLUGIN_RPC,
};
use serde_json::Value;
use std::path::Path;

#[derive(Default)]
struct State {}

register_plugin!(State);

fn initialize(params: InitializeParams) -> Result<()> {
    PLUGIN_RPC.stderr("lapce-haskell");
    let document_selector: DocumentSelector = vec![DocumentFilter {
        language: Some(String::from("haskell")),
        pattern: None,
        scheme: None,
    }];
    let volt_uri = VoltEnvironment::uri()?;
    let server_path = Url::parse(&volt_uri)
        .unwrap()
        .join("haskell-language-server-wrapper")?;
    let server_args = vec![String::from("--lsp")];
    PLUGIN_RPC.start_lsp(
        server_path,
        server_args,
        document_selector,
        params.initialization_options,
    );

    Ok(())
}

impl LapcePlugin for State {
    fn handle_request(&mut self, _id: u64, method: String, params: Value) {
        #[allow(clippy::single_match)]
        match method.as_str() {
            Initialize::METHOD => {
                let params: InitializeParams = serde_json::from_value(params).unwrap();
                if let Err(e) = initialize(params) {
                    PLUGIN_RPC.stderr(&format!("plugin returned with error: {e}"))
                }
            }
            _ => {}
        }
    }
}
