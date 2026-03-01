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

/* server/status/monitor/index.twig */
class __TwigTemplate_1b718cd54aed7b96799774aeeb21fef1 extends Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->blocks = [
            'content' => [$this, 'block_content'],
        ];
    }

    protected function doGetParent(array $context)
    {
        // line 1
        return "server/status/base.twig";
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 2
        $context["active"] = "monitor";
        // line 1
        $this->parent = $this->loadTemplate("server/status/base.twig", "server/status/monitor/index.twig", 1);
        yield from $this->parent->unwrap()->yield($context, array_merge($this->blocks, $blocks));
    }

    // line 3
    public function block_content($context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 4
        yield "
<div class=\"tabLinks row\">
  <a href=\"#pauseCharts\">
    ";
        // line 7
        yield PhpMyAdmin\Html\Generator::getImage("play");
yield _gettext("Start Monitor");
        // line 9
        yield "</a>
  <a href=\"#settingsPopup\" class=\"popupLink\">
    ";
        // line 11
        yield PhpMyAdmin\Html\Generator::getImage("s_cog");
yield _gettext("Settings");
        // line 13
        yield "</a>
  <a href=\"#monitorInstructionsDialog\">
    ";
        // line 15
        yield PhpMyAdmin\Html\Generator::getImage("b_help");
yield _gettext("Instructions/Setup");
        // line 17
        yield "</a>
  <a href=\"#endChartEditMode\" class=\"hide\">
    ";
        // line 19
        yield PhpMyAdmin\Html\Generator::getImage("s_okay");
yield _gettext("Done dragging (rearranging) charts");
        // line 21
        yield "</a>
</div>

<div class=\"popupContent settingsPopup\">
  <a href=\"#addNewChart\">
    ";
        // line 26
        yield PhpMyAdmin\Html\Generator::getImage("b_chart");
        yield "
    ";
yield _gettext("Add chart");
        // line 28
        yield "  </a>
  <a href=\"#rearrangeCharts\">
    ";
        // line 30
        yield PhpMyAdmin\Html\Generator::getImage("b_tblops");
        yield "
    ";
yield _gettext("Enable charts dragging");
        // line 32
        yield "  </a>
  <div class=\"clearfloat paddingtop\"></div>

  <div class=\"float-start\">
    ";
yield _gettext("Refresh rate");
        // line 37
        yield "    <br>
    <select id=\"id_gridChartRefresh\" class=\"refreshRate\" name=\"gridChartRefresh\">
      ";
        // line 39
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable([2, 3, 4, 5, 10, 20, 40, 60, 120, 300, 600, 1200]);
        foreach ($context['_seq'] as $context["_key"] => $context["rate"]) {
            // line 40
            yield "        <option value=\"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["rate"], "html", null, true);
            yield "\"";
            yield ((($context["rate"] == 5)) ? (" selected") : (""));
            yield ">
          ";
            // line 41
            if (($context["rate"] < 60)) {
                // line 42
                yield "            ";
                if (($context["rate"] == 1)) {
                    // line 43
                    yield "              ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("%d second"), $context["rate"]), "html", null, true);
                    yield "
            ";
                } else {
                    // line 45
                    yield "              ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("%d seconds"), $context["rate"]), "html", null, true);
                    yield "
            ";
                }
                // line 47
                yield "          ";
            } else {
                // line 48
                yield "            ";
                if ((($context["rate"] / 60) == 1)) {
                    // line 49
                    yield "              ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("%d minute"), ($context["rate"] / 60)), "html", null, true);
                    yield "
            ";
                } else {
                    // line 51
                    yield "              ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("%d minutes"), ($context["rate"] / 60)), "html", null, true);
                    yield "
            ";
                }
                // line 53
                yield "          ";
            }
            // line 54
            yield "        </option>
      ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['rate'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 56
        yield "    </select>
    <br>
  </div>

  <div class=\"float-start\">
    ";
yield _gettext("Chart columns");
        // line 62
        yield "    <br>
    <select name=\"chartColumns\">
      <option>1</option>
      <option>2</option>
      <option>3</option>
      <option>4</option>
      <option>5</option>
      <option>6</option>
    </select>
  </div>

  <div class=\"clearfloat paddingtop\">
    <strong>";
yield _gettext("Chart arrangement");
        // line 74
        yield "</strong>
    ";
        // line 75
        yield PhpMyAdmin\Html\Generator::showHint(_gettext("The arrangement of the charts is stored to the browsers local storage. You may want to export it if you have a complicated set up."));
        yield "
    <br>
    <a class=\"ajax\" href=\"#importMonitorConfig\">
      ";
yield _gettext("Import");
        // line 79
        yield "    </a> -
    <a class=\"disableAjax\" href=\"#exportMonitorConfig\">
      ";
yield _gettext("Export");
        // line 82
        yield "    </a> -
    <a href=\"#clearMonitorConfig\">
      ";
yield _gettext("Reset to default");
        // line 85
        yield "    </a>
  </div>
</div>

<div id=\"monitorInstructionsDialog\" title=\"";
yield _gettext("Monitor Instructions");
        // line 89
        yield "\" class=\"hide\">
  <p>
    ";
yield _gettext("The phpMyAdmin Monitor can assist you in optimizing the server configuration and track down time intensive queries. For the latter you will need to set log_output to 'TABLE' and have either the slow_query_log or general_log enabled. Note however, that the general_log produces a lot of data and increases server load by up to 15%.");
        // line 94
        yield "  </p>
  <img class=\"ajaxIcon\" src=\"";
        // line 95
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($this->extensions['PhpMyAdmin\Twig\AssetExtension']->getImagePath("ajax_clock_small.gif"), "html", null, true);
        yield "\" alt=\"";
yield _gettext("Loading…");
        yield "\">

  <div class=\"ajaxContent\"></div>
  <br>

  <div class=\"monitorUse hide\">
    <p><strong>";
yield _gettext("Using the monitor:");
        // line 101
        yield "</strong></p>
    <p>
      ";
yield _gettext("Your browser will refresh all displayed charts in a regular interval. You may add charts and change the refresh rate under 'Settings', or remove any chart using the cog icon on each respective chart.");
        // line 106
        yield "    </p>
    <p>
      ";
yield _gettext("To display queries from the logs, select the relevant time span on any chart by holding down the left mouse button and panning over the chart. Once confirmed, this will load a table of grouped queries, there you may click on any occurring SELECT statements to further analyze them.");
        // line 111
        yield "    </p>
    <p>
      ";
        // line 113
        yield PhpMyAdmin\Html\Generator::getImage("s_attention");
        yield "
      <strong>";
yield _gettext("Please note:");
        // line 114
        yield "</strong>
    </p>
    <p>
      ";
yield _gettext("Enabling the general_log may increase the server load by 5-15%. Also be aware that generating statistics from the logs is a load intensive task, so it is advisable to select only a small time span and to disable the general_log and empty its table once monitoring is not required any more.");
        // line 120
        yield "    </p>
  </div>
</div>

<div class=\"modal fade\" id=\"addChartModal\" tabindex=\"-1\" aria-labelledby=\"addChartModalLabel\" aria-hidden=\"true\">
  <div class=\"modal-dialog\">
    <div class=\"modal-content\">
      <div class=\"modal-header\">
        <h5 class=\"modal-title\" id=\"addChartModalLabel\">";
yield _gettext("Chart Title");
        // line 128
        yield "</h5>
        <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"";
yield _gettext("Close");
        // line 129
        yield "\"></button>
      </div>
      <div class=\"modal-body\">
        <div id=\"tabGridVariables\">
          <p>
            <input type=\"text\" name=\"chartTitle\" value=\"";
yield _gettext("Chart Title");
        // line 134
        yield "\">
          </p>
          <input type=\"radio\" name=\"chartType\" value=\"preset\" id=\"chartPreset\">

          <label for=\"chartPreset\">";
yield _gettext("Preset chart");
        // line 138
        yield "</label>
          <select name=\"presetCharts\"></select>
          <br>

          <input type=\"radio\" name=\"chartType\" value=\"variable\" id=\"chartStatusVar\" checked=\"checked\">
          <label for=\"chartStatusVar\">
            ";
yield _gettext("Status variable(s)");
        // line 145
        yield "          </label>
          <br>

          <div id=\"chartVariableSettings\">
            <label for=\"chartSeries\">";
yield _gettext("Select series:");
        // line 149
        yield "</label>
            <br>
            <select id=\"chartSeries\" name=\"varChartList\" size=\"1\">
              <option>";
yield _gettext("Commonly monitored");
        // line 152
        yield "</option>
              <option>Processes</option>
              <option>Questions</option>
              <option>Connections</option>
              <option>Bytes_sent</option>
              <option>Bytes_received</option>
              <option>Threads_connected</option>
              <option>Created_tmp_disk_tables</option>
              <option>Handler_read_first</option>
              <option>Innodb_buffer_pool_wait_free</option>
              <option>Key_reads</option>
              <option>Open_tables</option>
              <option>Select_full_join</option>
              <option>Slow_queries</option>
            </select>
            <br>

            <label for=\"variableInput\">
              ";
yield _gettext("or type variable name:");
        // line 171
        yield "            </label>
            <input type=\"text\" name=\"variableInput\" id=\"variableInput\">
            <br>

            <input type=\"checkbox\" name=\"differentialValue\" id=\"differentialValue\" value=\"differential\" checked=\"checked\">
            <label for=\"differentialValue\">
              ";
yield _gettext("Display as differential value");
        // line 178
        yield "            </label>
            <br>

            <input type=\"checkbox\" id=\"useDivisor\" name=\"useDivisor\" value=\"1\">
            <label for=\"useDivisor\">";
yield _gettext("Apply a divisor");
        // line 182
        yield "</label>

            <span class=\"divisorInput hide\">
              <input type=\"text\" name=\"valueDivisor\" size=\"4\" value=\"1\">
              (<a href=\"#kibDivisor\">";
yield _gettext("KiB");
        // line 186
        yield "</a>,
              <a href=\"#mibDivisor\">";
yield _gettext("MiB");
        // line 187
        yield "</a>)
            </span>
            <br>

            <input type=\"checkbox\" id=\"useUnit\" name=\"useUnit\" value=\"1\">
            <label for=\"useUnit\">
              ";
yield _gettext("Append unit to data values");
        // line 194
        yield "            </label>
            <span class=\"unitInput hide\">
              <input type=\"text\" name=\"valueUnit\" size=\"4\" value=\"\">
            </span>

            <p>
              <a href=\"#submitAddSeries\">
                <strong>";
yield _gettext("Add this series");
        // line 201
        yield "</strong>
              </a>
              <span id=\"clearSeriesLink\" class=\"hide\">
                | <a href=\"#submitClearSeries\">";
yield _gettext("Clear series");
        // line 204
        yield "</a>
              </span>
            </p>

            ";
yield _gettext("Series in chart:");
        // line 209
        yield "            <br>
            <span id=\"seriesPreview\">
              <em>";
yield _gettext("None");
        // line 211
        yield "</em>
            </span>
          </div>
        </div>
      </div>
      <div class=\"modal-footer\">
        <button type=\"button\" class=\"btn btn-secondary\" id=\"addChartButton\" data-bs-dismiss=\"modal\">";
yield _gettext("Add chart to grid");
        // line 217
        yield "</button>
        <button type=\"button\" class=\"btn btn-secondary\" id=\"closeModalButton\" data-bs-dismiss=\"modal\">";
yield _gettext("Close");
        // line 218
        yield "</button>
      </div>
    </div>
  </div>
</div>

<div id=\"logAnalyseDialog\" title=\"";
yield _gettext("Log statistics");
        // line 224
        yield "\" class=\"hide\">
  <p>
    ";
yield _gettext("Selected time range:");
        // line 227
        yield "    <input type=\"text\" name=\"dateStart\" class=\"datetimefield\" value=\"\">
    -
    <input type=\"text\" name=\"dateEnd\" class=\"datetimefield\" value=\"\">
  </p>

  <input type=\"checkbox\" id=\"limitTypes\" value=\"1\" checked=\"checked\">
  <label for=\"limitTypes\">
    ";
yield _gettext("Only retrieve SELECT,INSERT,UPDATE and DELETE Statements");
        // line 235
        yield "  </label>
  <br>

  <input type=\"checkbox\" id=\"removeVariables\" value=\"1\" checked=\"checked\">
  <label for=\"removeVariables\">
    ";
yield _gettext("Remove variable data in INSERT statements for better grouping");
        // line 241
        yield "  </label>

  <p>
    ";
yield _gettext("Choose from which log you want the statistics to be generated from.");
        // line 245
        yield "  </p>
  <p>
    ";
yield _gettext("Results are grouped by query text.");
        // line 248
        yield "  </p>
</div>

<div id=\"queryAnalyzerDialog\" title=\"";
yield _gettext("Query analyzer");
        // line 251
        yield "\" class=\"hide\">
  <textarea id=\"sqlquery\"></textarea>
  <br>
  <div class=\"placeHolder\"></div>
</div>

<div class=\"clearfloat\"></div>
<div><table class=\"clearfloat tdblock\" id=\"chartGrid\"></table></div>
<div id=\"logTable\"><br></div>

<script type=\"text/javascript\">
  var variableNames = [
    ";
        // line 263
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["javascript_variable_names"] ?? null));
        foreach ($context['_seq'] as $context["_key"] => $context["variable_name"]) {
            // line 264
            yield "      \"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["variable_name"], "js"), "html", null, true);
            yield "\",
    ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['variable_name'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 266
        yield "  ];
</script>

<form id=\"js_data\" class=\"hide\">
  ";
        // line 270
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["form"] ?? null));
        foreach ($context['_seq'] as $context["name"] => $context["value"]) {
            // line 271
            yield "    <input type=\"hidden\" name=\"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["name"], "html", null, true);
            yield "\" value=\"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["value"], "html", null, true);
            yield "\">
  ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['name'], $context['value'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 273
        yield "</form>

<div id=\"profiling_docu\" class=\"hide\">
  ";
        // line 276
        yield PhpMyAdmin\Html\MySQLDocumentation::show("general-thread-states");
        yield "
</div>

<div id=\"explain_docu\" class=\"hide\">
  ";
        // line 280
        yield PhpMyAdmin\Html\MySQLDocumentation::show("explain-output");
        yield "
</div>

";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/status/monitor/index.twig";
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
        return array (  525 => 280,  518 => 276,  513 => 273,  502 => 271,  498 => 270,  492 => 266,  483 => 264,  479 => 263,  465 => 251,  459 => 248,  454 => 245,  448 => 241,  440 => 235,  430 => 227,  425 => 224,  416 => 218,  412 => 217,  403 => 211,  398 => 209,  391 => 204,  385 => 201,  375 => 194,  366 => 187,  362 => 186,  355 => 182,  348 => 178,  339 => 171,  318 => 152,  312 => 149,  305 => 145,  296 => 138,  289 => 134,  281 => 129,  277 => 128,  266 => 120,  260 => 114,  255 => 113,  251 => 111,  246 => 106,  241 => 101,  229 => 95,  226 => 94,  221 => 89,  214 => 85,  209 => 82,  204 => 79,  197 => 75,  194 => 74,  179 => 62,  171 => 56,  164 => 54,  161 => 53,  155 => 51,  149 => 49,  146 => 48,  143 => 47,  137 => 45,  131 => 43,  128 => 42,  126 => 41,  119 => 40,  115 => 39,  111 => 37,  104 => 32,  99 => 30,  95 => 28,  90 => 26,  83 => 21,  80 => 19,  76 => 17,  73 => 15,  69 => 13,  66 => 11,  62 => 9,  59 => 7,  54 => 4,  50 => 3,  45 => 1,  43 => 2,  36 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/status/monitor/index.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\status\\monitor\\index.twig");
    }
}
