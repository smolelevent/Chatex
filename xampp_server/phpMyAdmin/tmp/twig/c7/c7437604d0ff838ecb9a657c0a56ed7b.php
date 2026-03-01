<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Extension\CoreExtension;
use Twig\Extension\SandboxExtension;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;

/* database/tracking/tables.twig */
class __TwigTemplate_a7c2ffd5ddc5275cff3b28268c980e9a extends Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
        ];
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 2
        if (($context["head_version_exists"] ?? null)) {
            // line 3
            yield "    <div id=\"tracked_tables\">
        <h3>";
yield _gettext("Tracked tables");
            // line 4
            yield "</h3>

        <form method=\"post\" action=\"";
            // line 6
            yield PhpMyAdmin\Url::getFromRoute("/database/tracking");
            yield "\" name=\"trackedForm\"
            id=\"trackedForm\" class=\"ajax\">
            ";
            // line 8
            yield PhpMyAdmin\Url::getHiddenInputs(($context["db"] ?? null));
            yield "
            <table id=\"versions\" class=\"table table-striped table-hover w-auto\">
                <thead>
                    <tr>
                        <th></th>
                        <th>";
yield _gettext("Table");
            // line 13
            yield "</th>
                        <th>";
yield _gettext("Last version");
            // line 14
            yield "</th>
                        <th>";
yield _gettext("Created");
            // line 15
            yield "</th>
                        <th>";
yield _gettext("Updated");
            // line 16
            yield "</th>
                        <th>";
yield _gettext("Status");
            // line 17
            yield "</th>
                        <th>";
yield _gettext("Action");
            // line 18
            yield "</th>
                        <th>";
yield _gettext("Show");
            // line 19
            yield "</th>
                    </tr>
                </thead>
                <tbody>
                    ";
            // line 23
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["versions"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["version"]) {
                // line 24
                yield "                        <tr>
                            <td class=\"text-center\">
                                <input type=\"checkbox\" name=\"selected_tbl[]\"
                                    class=\"checkall\" id=\"selected_tbl_";
                // line 27
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["version"], "table_name", [], "any", false, false, false, 27), "html", null, true);
                yield "\"
                                    value=\"";
                // line 28
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["version"], "table_name", [], "any", false, false, false, 28), "html", null, true);
                yield "\">
                            </td>
                            <th>
                                <label for=\"selected_tbl_";
                // line 31
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["version"], "table_name", [], "any", false, false, false, 31), "html", null, true);
                yield "\">
                                    ";
                // line 32
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["version"], "table_name", [], "any", false, false, false, 32), "html", null, true);
                yield "
                                </label>
                            </th>
                            <td class=\"text-end\">
                                ";
                // line 36
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["version"], "version", [], "any", false, false, false, 36), "html", null, true);
                yield "
                            </td>
                            <td>
                                ";
                // line 39
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["version"], "date_created", [], "any", false, false, false, 39), "html", null, true);
                yield "
                            </td>
                            <td>
                                ";
                // line 42
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["version"], "date_updated", [], "any", false, false, false, 42), "html", null, true);
                yield "
                            </td>
                            <td>
                              <div class=\"wrapper toggleAjax hide\">
                                <div class=\"toggleButton\">
                                  <div title=\"";
yield _gettext("Click to toggle");
                // line 47
                yield "\" class=\"toggle-container ";
                yield (((CoreExtension::getAttribute($this->env, $this->source, $context["version"], "tracking_active", [], "any", false, false, false, 47) == 1)) ? ("on") : ("off"));
                yield "\">
                                    <img src=\"";
                // line 48
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($this->extensions['PhpMyAdmin\Twig\AssetExtension']->getImagePath((("toggle-" . ($context["text_dir"] ?? null)) . ".png")), "html", null, true);
                yield "\">
                                    <table>
                                      <tbody>
                                      <tr>
                                        <td class=\"toggleOn\">
                                          <span class=\"hide\">";
                // line 54
                yield PhpMyAdmin\Url::getFromRoute("/table/tracking", ["db" => CoreExtension::getAttribute($this->env, $this->source,                 // line 55
$context["version"], "db_name", [], "any", false, false, false, 55), "table" => CoreExtension::getAttribute($this->env, $this->source,                 // line 56
$context["version"], "table_name", [], "any", false, false, false, 56), "version" => CoreExtension::getAttribute($this->env, $this->source,                 // line 57
$context["version"], "version", [], "any", false, false, false, 57), "toggle_activation" => "activate_now"]);
                // line 60
                yield "</span>
                                          <div>";
yield _gettext("active");
                // line 61
                yield "</div>
                                        </td>
                                        <td><div>&nbsp;</div></td>
                                        <td class=\"toggleOff\">
                                          <span class=\"hide\">";
                // line 66
                yield PhpMyAdmin\Url::getFromRoute("/table/tracking", ["db" => CoreExtension::getAttribute($this->env, $this->source,                 // line 67
$context["version"], "db_name", [], "any", false, false, false, 67), "table" => CoreExtension::getAttribute($this->env, $this->source,                 // line 68
$context["version"], "table_name", [], "any", false, false, false, 68), "version" => CoreExtension::getAttribute($this->env, $this->source,                 // line 69
$context["version"], "version", [], "any", false, false, false, 69), "toggle_activation" => "deactivate_now"]);
                // line 72
                yield "</span>
                                          <div>";
yield _gettext("not active");
                // line 73
                yield "</div>
                                        </td>
                                      </tr>
                                      </tbody>
                                    </table>
                                    <span class=\"hide callback\"></span>
                                    <span class=\"hide text_direction\">";
                // line 79
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["text_dir"] ?? null), "html", null, true);
                yield "</span>
                                  </div>
                                </div>
                              </div>
                            </td>
                            <td>
                                <a class=\"delete_tracking_anchor ajax\" href=\"";
                // line 85
                yield PhpMyAdmin\Url::getFromRoute("/database/tracking");
                yield "\" data-post=\"";
                // line 86
                yield PhpMyAdmin\Url::getCommon(["db" =>                 // line 87
($context["db"] ?? null), "goto" => PhpMyAdmin\Url::getFromRoute("/table/tracking"), "back" => PhpMyAdmin\Url::getFromRoute("/database/tracking"), "table" => CoreExtension::getAttribute($this->env, $this->source,                 // line 90
$context["version"], "table_name", [], "any", false, false, false, 90), "delete_tracking" => true], "", false);
                // line 92
                yield "\">
                                    ";
                // line 93
                yield PhpMyAdmin\Html\Generator::getIcon("b_drop", _gettext("Delete tracking"));
                yield "
                                </a>
                            </td>
                            <td>
                                <a href=\"";
                // line 97
                yield PhpMyAdmin\Url::getFromRoute("/table/tracking");
                yield "\" data-post=\"";
                // line 98
                yield PhpMyAdmin\Url::getCommon(["db" =>                 // line 99
($context["db"] ?? null), "goto" => PhpMyAdmin\Url::getFromRoute("/table/tracking"), "back" => PhpMyAdmin\Url::getFromRoute("/database/tracking"), "table" => CoreExtension::getAttribute($this->env, $this->source,                 // line 102
$context["version"], "table_name", [], "any", false, false, false, 102)], "", false);
                // line 103
                yield "\">
                                    ";
                // line 104
                yield PhpMyAdmin\Html\Generator::getIcon("b_versions", _gettext("Versions"));
                yield "
                                </a>
                                <a href=\"";
                // line 106
                yield PhpMyAdmin\Url::getFromRoute("/table/tracking");
                yield "\" data-post=\"";
                // line 107
                yield PhpMyAdmin\Url::getCommon(["db" =>                 // line 108
($context["db"] ?? null), "goto" => PhpMyAdmin\Url::getFromRoute("/table/tracking"), "back" => PhpMyAdmin\Url::getFromRoute("/database/tracking"), "table" => CoreExtension::getAttribute($this->env, $this->source,                 // line 111
$context["version"], "table_name", [], "any", false, false, false, 111), "report" => true, "version" => CoreExtension::getAttribute($this->env, $this->source,                 // line 113
$context["version"], "version", [], "any", false, false, false, 113)], "", false);
                // line 114
                yield "\">
                                    ";
                // line 115
                yield PhpMyAdmin\Html\Generator::getIcon("b_report", _gettext("Tracking report"));
                yield "
                                </a>
                                <a href=\"";
                // line 117
                yield PhpMyAdmin\Url::getFromRoute("/table/tracking");
                yield "\" data-post=\"";
                // line 118
                yield PhpMyAdmin\Url::getCommon(["db" =>                 // line 119
($context["db"] ?? null), "goto" => PhpMyAdmin\Url::getFromRoute("/table/tracking"), "back" => PhpMyAdmin\Url::getFromRoute("/database/tracking"), "table" => CoreExtension::getAttribute($this->env, $this->source,                 // line 122
$context["version"], "table_name", [], "any", false, false, false, 122), "snapshot" => true, "version" => CoreExtension::getAttribute($this->env, $this->source,                 // line 124
$context["version"], "version", [], "any", false, false, false, 124)], "", false);
                // line 125
                yield "\">
                                    ";
                // line 126
                yield PhpMyAdmin\Html\Generator::getIcon("b_props", _gettext("Structure snapshot"));
                yield "
                                </a>
                            </td>
                        </tr>
                    ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['version'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 131
            yield "                </tbody>
            </table>
            ";
            // line 133
            yield from             $this->loadTemplate("select_all.twig", "database/tracking/tables.twig", 133)->unwrap()->yield(CoreExtension::toArray(["text_dir" =>             // line 134
($context["text_dir"] ?? null), "form_name" => "trackedForm"]));
            // line 137
            yield "            <button class=\"btn btn-link mult_submit\" type=\"submit\" name=\"submit_mult\" value=\"delete_tracking\"
                    title=\"";
yield _gettext("Delete tracking");
            // line 138
            yield "\">
                ";
            // line 139
            yield PhpMyAdmin\Html\Generator::getIcon("b_drop", _gettext("Delete tracking"));
            yield "
            </button>
        </form>
    </div>
";
        }
        // line 144
        if (($context["untracked_tables_exists"] ?? null)) {
            // line 145
            yield "    <h3>";
yield _gettext("Untracked tables");
            yield "</h3>
    <form method=\"post\" action=\"";
            // line 146
            yield PhpMyAdmin\Url::getFromRoute("/database/tracking");
            yield "\" name=\"untrackedForm\"
        id=\"untrackedForm\" class=\"ajax\">
        ";
            // line 148
            yield PhpMyAdmin\Url::getHiddenInputs(($context["db"] ?? null));
            yield "
        <table id=\"noversions\" class=\"table table-striped table-hover w-auto\">
            <thead>
                <tr>
                    <th></th>
                    <th>";
yield _gettext("Table");
            // line 153
            yield "</th>
                    <th>";
yield _gettext("Action");
            // line 154
            yield "</th>
                </tr>
            </thead>
            <tbody>
                ";
            // line 158
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["untracked_tables"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["table_name"]) {
                // line 159
                yield "                  ";
                if ((PhpMyAdmin\Tracker::getVersion(($context["db"] ?? null), $context["table_name"]) ==  -1)) {
                    // line 160
                    yield "                    <tr>
                        <td class=\"text-center\">
                            <input type=\"checkbox\" name=\"selected_tbl[]\"
                                class=\"checkall\" id=\"selected_tbl_";
                    // line 163
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["table_name"], "html", null, true);
                    yield "\"
                                value=\"";
                    // line 164
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["table_name"], "html", null, true);
                    yield "\">
                        </td>
                        <th>
                            <label for=\"selected_tbl_";
                    // line 167
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["table_name"], "html", null, true);
                    yield "\">
                                ";
                    // line 168
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["table_name"], "html", null, true);
                    yield "
                            </label>
                        </th>
                        <td>
                            <a href=\"";
                    // line 172
                    yield PhpMyAdmin\Url::getFromRoute("/table/tracking", Twig\Extension\CoreExtension::merge(($context["url_params"] ?? null), ["db" =>                     // line 173
($context["db"] ?? null), "table" =>                     // line 174
$context["table_name"]]));
                    // line 175
                    yield "\">
                                ";
                    // line 176
                    yield PhpMyAdmin\Html\Generator::getIcon("eye", _gettext("Track table"));
                    yield "
                            </a>
                        </td>
                    </tr>
                  ";
                }
                // line 181
                yield "                ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['table_name'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 182
            yield "            </tbody>
        </table>
        ";
            // line 184
            yield from             $this->loadTemplate("select_all.twig", "database/tracking/tables.twig", 184)->unwrap()->yield(CoreExtension::toArray(["text_dir" =>             // line 185
($context["text_dir"] ?? null), "form_name" => "untrackedForm"]));
            // line 188
            yield "        <button class=\"btn btn-link mult_submit\" type=\"submit\" name=\"submit_mult\" value=\"track\" title=\"";
yield _gettext("Track table");
            yield "\">
            ";
            // line 189
            yield PhpMyAdmin\Html\Generator::getIcon("eye", _gettext("Track table"));
            yield "
        </button>
    </form>
";
        }
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "database/tracking/tables.twig";
    }

    /**
     * @codeCoverageIgnore
     */
    public function isTraitable()
    {
        return false;
    }

    /**
     * @codeCoverageIgnore
     */
    public function getDebugInfo()
    {
        return array (  386 => 189,  381 => 188,  379 => 185,  378 => 184,  374 => 182,  368 => 181,  360 => 176,  357 => 175,  355 => 174,  354 => 173,  353 => 172,  346 => 168,  342 => 167,  336 => 164,  332 => 163,  327 => 160,  324 => 159,  320 => 158,  314 => 154,  310 => 153,  301 => 148,  296 => 146,  291 => 145,  289 => 144,  281 => 139,  278 => 138,  274 => 137,  272 => 134,  271 => 133,  267 => 131,  256 => 126,  253 => 125,  251 => 124,  250 => 122,  249 => 119,  248 => 118,  245 => 117,  240 => 115,  237 => 114,  235 => 113,  234 => 111,  233 => 108,  232 => 107,  229 => 106,  224 => 104,  221 => 103,  219 => 102,  218 => 99,  217 => 98,  214 => 97,  207 => 93,  204 => 92,  202 => 90,  201 => 87,  200 => 86,  197 => 85,  188 => 79,  180 => 73,  176 => 72,  174 => 69,  173 => 68,  172 => 67,  171 => 66,  165 => 61,  161 => 60,  159 => 57,  158 => 56,  157 => 55,  156 => 54,  148 => 48,  143 => 47,  134 => 42,  128 => 39,  122 => 36,  115 => 32,  111 => 31,  105 => 28,  101 => 27,  96 => 24,  92 => 23,  86 => 19,  82 => 18,  78 => 17,  74 => 16,  70 => 15,  66 => 14,  62 => 13,  53 => 8,  48 => 6,  44 => 4,  40 => 3,  38 => 2,);
    }

    public function getSourceContext()
    {
        return new Source("", "database/tracking/tables.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\database\\tracking\\tables.twig");
    }
}
