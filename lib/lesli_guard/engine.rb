module LesliGuard
    class Engine < ::Rails::Engine
        isolate_namespace LesliGuard

        initializer :lesli_guard do |app|

            # register assets manifest
            config.assets.precompile += %w[lesli_guard_manifest.js]

            # register engine migrations path
            unless app.root.to_s.match root.to_s
                config.paths["db/migrate"].expanded.each do |expanded_path|
                    app.config.paths["db/migrate"] << expanded_path
                end
            end
        end
    end
end
