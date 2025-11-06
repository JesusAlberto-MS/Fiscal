[
  # Para ver más opciones, consultar `mix help check`
  parallel: true,
  skipped: false,
  retry: false,
  tools: [
    {:credo, "mix credo --strict -a"},
    {:ex_unit, "mix coveralls --warnings-as-errors"},
    {:sobelow, "mix sobelow --config"},
    {:doctor, false},
    {:dialyzer, "mix dialyzer --plt"},

    ## las herramientas seleccionadas pueden estar deshabilitadas
    # (por ejemplo, la verificación de advertencias de compilación)
    # {:compiler, false},
    # {:npm_test, "npm run test"},
    {:npm_test, false},

    # ejecutar mix check y todas las herramientas
    # de las que depende en el entorno de prueba
    {:compiler, env: %{"MIX_ENV" => "test"}},
    {:dialyzer, env: %{"MIX_ENV" => "test"}},
    {:ex_doc, env: %{"MIX_ENV" => "dev"}},
    {:formatter, env: %{"MIX_ENV" => "test"}},

    # ...o ajustar el comando y los argumentos
    # (por ejemplo, habilitar omitir comentarios para `sobelow`)
    # {:sobelow, "mix sobelow --exit --skip"},

    ## ...o reordenado
    # (por ejemplo, para ver el resultado del dializador antes que otros)
    # {:dialyzer, order: -1},

    ## ...o reconfigurado
    # (por ejemplo, deshabilitar la ejecución paralela de ex_unit en umbrella)
    # {:ex_unit, umbrella: [parallel: false]},

    ## Se pueden agregar nuevas herramientas personalizadas
    # (mix tasks o comandos arbitrarios)
    # {:my_task, "mix my_task", env: %{"MIX_ENV" => "prod"}},
    # {:my_tool, ["my_tool", "arg with spaces"]}

    # Se requiere Sweet XML para ExAws/Dawdle, pero
    # https://github.com/kbrw/sweet_xml/issues/71 no ha sido resuelto todavía
    # {:audit, "mix deps.audit --ignore-package-names sweet_xml"},
    {:audit, "mix deps.audit"}

    # {:prettier, "npm run prettier-check"},
    # {:eslint, "npm run eslint"}
  ]
]
