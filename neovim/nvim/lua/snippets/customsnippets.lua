local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep

luasnip.config.setup({
    luasnip.add_snippets("cpp", {
        s("printvector", {
            t("for (size_t i = 0; i < "), i(1), t(".size(); ++i) {"),
            t({ "", "\tstd::cout << " }), rep(1), t({ "[i] << std::endl;", "" }),
            t({ "}", "" }),
        })
    }),

    luasnip.add_snippets("cpp", {
        s("header_cm", {
            t({
                "/* ----------------------------------------------------------------------------------- *\\",
                "|                                                                                       |",
                "|          ______                      __  ___      __       __    _                    |",
                "|         / ____/_  ________   _____  /  |/  /___ _/ /______/ /_  (_)___  ____ _        |",
                "|        / /   / / / / ___/ | / / _ \\/ /|_/ / __ `/ __/ ___/ __ \\/ / __ \\/ __ `/        |",
                "|       / /___/ /_/ / /   | |/ /  __/ /  / / /_/ / /_/ /__/ / / / / / / / /_/ /         |",
                "|       \\____/\\__,_/_/    |___/\\___/_/  /_/\\__,_/\\__/\\___/_/ /_/_/_/ /_/\\__, /          |",
                "|                                                                      /____/           |",
                "|                                                                                       |",
                "| ------------------------------------------------------------------------------------- |",
                "|  See license and copyright at the end of this file.                                   |",
                "| ------------------------------------------------------------------------------------- |",
                "|                                                                                       |",
                "|          Author: Timoteo Dinelli  <timoteo.dinelli@polimi.it>                         |",
                "|                                                                                       |",
                "|                  CRECK Modeling Lab <https://www.creckmodeling.polimi.it>             |",
                "|                  Department of Chemistry, Materials and Chemical Engineering          |",
                "|                  Politecnico di Milano, P.zza Leonardo da Vinci 32, 20133 Milano      |",
                "|                                                                                       |",
                "\\* ----------------------------------------------------------------------------------- */",
                "",
            }),
        })
    }),

    luasnip.add_snippets("cpp", {
        s("license_cm", {
            t({
                "/* ----------------------------------------------------------------------------------- *\\",
                "|                                                                                       |",
                "|     MIT License                                                                       |",
                "|                                                                                       |",
                "|     Copyright (c) 2025 Timoteo Dinelli                                                |",
                "|                                                                                       |",
                "|     Permission is hereby granted, free of charge, to any person obtaining a copy      |",
                "|     of this software and associated documentation files (the \"Software\"), to deal     |",
                "|     in the Software without restriction, including without limitation the rights      |",
                "|     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell         |",
                "|     copies of the Software, and to permit persons to whom the Software is             |",
                "|     furnished to do so, subject to the following conditions:                          |",
                "|                                                                                       |",
                "|     The above copyright notice and this permission notice shall be included in all    |",
                "|     copies or substantial portions of the Software.                                   |",
                "|                                                                                       |",
                "|     THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR        |",
                "|     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,          |",
                "|     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE       |",
                "|     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER            |",
                "|     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,     |",
                "|     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     |",
                "|     SOFTWARE.                                                                         |",
                "|                                                                                       |",
                "\\* ----------------------------------------------------------------------------------- */",
                ""
            })
        }),
    }),

    luasnip.add_snippets("cpp", {
        s("header_opti", {
            t({
                "/* ----------------------------------------------------------------------------------- *\\",
                "|                                                                                       |",
                "|                ____        __  _ _____ __  _______  __ __ ______                      |",
                "|               / __ \\____  / /_(_) ___//  |/  / __ \\/ //_// ____/___  ____             |",
                "|              / / / / __ \\/ __/ /\\__ \\/ /|_/ / / / / ,<  / __/ / __ \\/ __ \\            |",
                "|             / /_/ / /_/ / /_/ /___/ / /  / / /_/ / /| |/ /___/ /_/ / /_/ /            |",
                "|             \\____/ .___/\\__/_//____/_/  /_/\\____/_/ |_/_____/ .___/ .___/             |",
                "|                 /_/                                        /_/   /_/                  |",
                "|                                                                                       |",
                "| ------------------------------------------------------------------------------------- |",
                "|  See license and copyright at the end of this file.                                   |",
                "| ------------------------------------------------------------------------------------- |",
                "|                                                                                       |",
                "|           Authors: Timoteo Dinelli  <timoteo.dinelli@polimi.it>                       |",
                "|                    Andrea Bertolino <andrea.bertolino@ulb.be>                         |",
                "|                    Magnus Fürst     <magnus.furst@ulb.ac.be>                          |",
                "|                                                                                       |",
                "|           [1] CRECK Modeling Lab <https://www.creckmodeling.polimi.it>                |",
                "|               Department of Chemistry, Materials and Chemical Engineering             |",
                "|               Politecnico di Milano, P.zza Leonardo da Vinci 32, 20133 Milano         |",
                "|                                                                                       |",
                "|           [2] BRITE Research Group <https://brite-research.be>                        |",
                "|               Brussels Institute for Thermal-fluid systems and clean Energy           |",
                "|               Avenue F.D. Rooseveltlaan 50, Bruxelles 1050 Brussel                    |",
                "|                                                                                       |",
                "\\* ----------------------------------------------------------------------------------- */",
                "",
            }),
        })
    }),

    luasnip.add_snippets("cpp", {
        s("license_opti", {
            t({
                "/* ----------------------------------------------------------------------------------- *\\",
                "|                                                                                       |",
                "|     MIT License                                                                       |",
                "|                                                                                       |",
                "|     Copyright (c) 2025 Timoteo Dinelli, Andrea Bertolino, Magnus Fürst                |",
                "|                                                                                       |",
                "|     Permission is hereby granted, free of charge, to any person obtaining a copy      |",
                "|     of this software and associated documentation files (the \"Software\"), to deal     |",
                "|     in the Software without restriction, including without limitation the rights      |",
                "|     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell         |",
                "|     copies of the Software, and to permit persons to whom the Software is             |",
                "|     furnished to do so, subject to the following conditions:                          |",
                "|                                                                                       |",
                "|     The above copyright notice and this permission notice shall be included in all    |",
                "|     copies or substantial portions of the Software.                                   |",
                "|                                                                                       |",
                "|     THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR        |",
                "|     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,          |",
                "|     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE       |",
                "|     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER            |",
                "|     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,     |",
                "|     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     |",
                "|     SOFTWARE.                                                                         |",
                "|                                                                                       |",
                "\\* ----------------------------------------------------------------------------------- */",
                ""
            })
        }),

        luasnip.add_snippets("python", {
            s("main_snip", {
                t({
                    "def main():",
                    "\tprint(\"running main\")",
                    "",
                    "",
                    "if __name__ == \"__main__\":",
                    "\tmain()"
                })
            })
        })
    })
})
