<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Vend × Faturamento × Devolução × Metas</title>
<snk:load/>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<style>
:root {
  --bg:         #f5f3f0;
  --bg2:        #ebe8e3;
  --surface:    #f0ede8;
  --surface2:   #e5e2dd;
  --surface3:   #dcd9d4;
  --border:     rgba(0,0,0,0.08);
  --border2:    rgba(0,0,0,0.12);
  --text:       #2c2c2c;
  --text2:      #5a5a5a;
  --text3:      #8a8a8a;

  --green:      #22c98e;
  --green-dim:  rgba(34,201,142,0.12);
  --green-glow: rgba(34,201,142,0.25);
  --red:        #e05c6e;
  --red-dim:    rgba(224,92,110,0.12);
  --amber:      #f5a623;
  --amber-dim:  rgba(245,166,35,0.12);
  --blue:       #5b8af5;
  --blue-dim:   rgba(91,138,245,0.12);
  --purple:     #a78bfa;
  --purple-dim: rgba(167,139,250,0.12);

  --radius:    12px;
  --radius-sm: 7px;
  --radius-xs: 4px;

  --font: 'Segoe UI', system-ui, sans-serif;
  --mono: 'Segoe UI', system-ui, sans-serif;
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: var(--font);
  background: var(--bg);
  color: var(--text);
  font-size: 13.5px;
  line-height: 1.55;
  min-height: 100vh;
}

/* ── HEADER ── */
header {
  background: var(--bg2);
  border-bottom: 1px solid var(--border2);
  padding: 0 28px;
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: sticky;
  top: 0;
  z-index: 200;
  backdrop-filter: blur(12px);
}
.hd-left  { display: flex; align-items: center; gap: 14px; }
.hd-icon  {
  width: 36px; height: 36px;
  background: linear-gradient(135deg, var(--green), #1ab87d);
  border-radius: var(--radius-sm);
  display: flex; align-items: center; justify-content: center;
  font-size: 17px;
  box-shadow: 0 0 18px var(--green-glow);
}
.hd-title { font-size: 15px; font-weight: 600; letter-spacing: -0.3px; }
.hd-sub   { font-size: 11px; color: var(--text3); font-family: var(--mono); letter-spacing: 0.5px; }
.hd-right { display: flex; align-items: center; gap: 8px; }
#upd { font-size: 11px; color: var(--text3); font-family: var(--mono); }

/* ── LAYOUT ── */
.shell { display: grid; grid-template-columns: 280px 1fr; min-height: calc(100vh - 56px); }

/* ── SIDEBAR ── */
aside {
  background: var(--bg2);
  border-right: 1px solid var(--border);
  padding: 22px 18px;
  display: flex;
  flex-direction: column;
  gap: 22px;
}
.flt-label {
  font-size: 10px; font-weight: 600;
  color: var(--text3);
  text-transform: uppercase;
  letter-spacing: 1px;
  margin-bottom: 8px;
}
.flt-group { display: flex; flex-direction: column; gap: 10px; }
.flt-row label { font-size: 11.5px; color: var(--text2); display: block; margin-bottom: 4px; }

input[type=date], input[type=text], select {
  width: 100%;
  padding: 8px 11px;
  background: var(--surface);
  border: 1px solid var(--border2);
  border-radius: var(--radius-sm);
  color: var(--text);
  font-family: var(--font);
  font-size: 12.5px;
  outline: none;
  transition: border-color .15s;
}
input[type=date]:focus,
input[type=text]:focus,
select:focus { border-color: var(--green); }
input[type=date]::-webkit-calendar-picker-indicator { filter: invert(0.5); cursor: pointer; }
select option { background: var(--surface2); }

.btn {
  padding: 9px 18px;
  border-radius: var(--radius-sm);
  font-family: var(--font);
  font-size: 13px;
  font-weight: 500;
  border: none;
  cursor: pointer;
  width: 100%;
  transition: opacity .15s, transform .1s;
}
.btn:active { transform: scale(0.98); }
.btn-primary {
  background: var(--green);
  color: #0a1a12;
  box-shadow: 0 0 20px var(--green-glow);
}
.btn-primary:hover { opacity: 0.88; }
.btn-ghost {
  background: var(--surface);
  color: var(--text2);
  border: 1px solid var(--border2);
}
.btn-ghost:hover { background: var(--surface2); color: var(--text); }

.divider { height: 1px; background: var(--border); }

/* ── MAIN ── */
main {
  padding: 22px 26px;
  display: flex;
  flex-direction: column;
  gap: 20px;
  overflow: auto;
}

/* ── KPIs ── */
.kpis { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 12px; }
.kpi {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 14px 16px;
  position: relative;
  overflow: hidden;
  transition: border-color .2s;
}
.kpi:hover { border-color: var(--border2); }
.kpi-label { font-size: 10.5px; color: var(--text3); text-transform: uppercase; letter-spacing: 0.7px; margin-bottom: 6px; }
.kpi-val   { font-size: 21px; letter-spacing: -0.5px; font-family: var(--mono); }
.kpi-sub   { font-size: 11px; color: var(--text3); margin-top: 2px; }
.kpi-bar   {
  position: absolute; bottom: 0; left: 0; right: 0;
  height: 3px;
  border-radius: 0 0 var(--radius) var(--radius);
}
.kpi.g .kpi-bar { background: var(--green); }
.kpi.r .kpi-bar { background: var(--red); }
.kpi.a .kpi-bar { background: var(--amber); }
.kpi.b .kpi-bar { background: var(--blue); }
.kpi.p .kpi-bar { background: var(--purple); }

/* ── CHARTS ROW ── */
.charts {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 14px;
}
.chart-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 16px 18px;
}
.chart-title {
  font-size: 12px; font-weight: 600;
  color: var(--text2);
  text-transform: uppercase;
  letter-spacing: 0.6px;
  margin-bottom: 14px;
}

/* ── TABLE CARD ── */
.tcard {
  background: #f5f3f0;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
}
.tcard-head {
  padding: 14px 18px;
  border-bottom: 1px solid var(--border);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}
.tcard-title { font-size: 13.5px; font-weight: 600; }
.srch-wrap { position: relative; }
.srch-wrap input { padding-left: 30px; width: 240px; }
.srch-ico { position: absolute; left: 9px; top: 50%; transform: translateY(-50%); color: var(--text3); pointer-events: none; }

.twrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }

thead th {
  padding: 9px 12px;
  text-align: left;
  font-size: 10px; font-weight: 600;
  color: var(--text3);
  text-transform: uppercase;
  letter-spacing: 0.6px;
  background: var(--surface2);
  border-bottom: 1px solid var(--border);
  white-space: nowrap;
  cursor: pointer;
  user-select: none;
  position: sticky; top: 0;
}
thead th:hover { color: var(--text); }
thead th.sort-asc::after  { content: ' ↑'; color: var(--green); }
thead th.sort-desc::after { content: ' ↓'; color: var(--green); }

tbody tr {
  border-bottom: 1px solid var(--border);
  cursor: pointer;
  transition: background .1s;
}
tbody tr:hover { background: var(--surface2); }
tbody tr:last-child { border-bottom: none; }
tbody td { padding: 9px 12px; white-space: nowrap; font-size: 12.5px; }
tbody tr.selected { background: var(--green-dim) !important; }
tbody tr.selected td { color: var(--green); }

.no-data, .loading-row {
  text-align: center; padding: 40px 20px;
  color: var(--text3); font-style: italic;
}

/* ── BADGES ── */
.badge {
  display: inline-flex; align-items: center;
  padding: 2px 9px; border-radius: 20px;
  font-size: 10px; font-weight: 600;
  font-family: var(--mono);
}
.badge-g { background: var(--green-dim); color: var(--green); }
.badge-r { background: var(--red-dim);   color: var(--red);   }
.badge-a { background: var(--amber-dim); color: var(--amber); }
.badge-b { background: var(--blue-dim);  color: var(--blue);  }

/* ── PROGRESS BAR ── */
.prog-wrap { display: flex; align-items: center; gap: 8px; min-width: 130px; }
.prog-bar { flex: 1; height: 5px; background: var(--surface3); border-radius: 99px; overflow: hidden; }
.prog-fill { height: 100%; border-radius: 99px; transition: width .4s; }
.prog-pct { font-size: 11px; font-family: var(--mono); color: var(--text2); min-width: 38px; text-align: right; }

/* ── PAGINAÇÃO ── */
.pag {
  padding: 11px 18px;
  border-top: 1px solid var(--border);
  display: flex; align-items: center; justify-content: space-between;
  font-size: 11.5px; color: var(--text3);
}
.pag-btns { display: flex; gap: 4px; }
.pb {
  padding: 4px 10px;
  border: 1px solid var(--border2);
  background: var(--surface2);
  border-radius: var(--radius-xs);
  cursor: pointer;
  font-size: 12px;
  color: var(--text2);
  font-family: var(--mono);
}
.pb:hover { background: var(--surface3); color: var(--text); }
.pb.act { background: var(--green); color: #0a1a12; border-color: var(--green); font-weight: 600; }

/* ── DETALHE DRAWER ── */
.drawer-overlay {
  display: none;
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.6);
  z-index: 300;
  backdrop-filter: blur(3px);
  animation: fadeIn .15s;
}
.drawer-overlay.open { display: flex; align-items: flex-end; justify-content: flex-end; }
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

.drawer {
  width: 70vw;
  height: 100vh;
  background: var(--bg2);
  border-left: 1px solid var(--border2);
  display: flex;
  flex-direction: column;
  animation: slideIn .2s ease-out;
}
@keyframes slideIn { from { transform: translateX(60px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

.drawer-head {
  padding: 16px 22px;
  border-bottom: 1px solid var(--border);
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.drawer-title { font-size: 15px; font-weight: 600; }
.drawer-sub   { font-size: 11.5px; color: var(--text3); margin-top: 2px; }
.btn-close {
  width: 32px; height: 32px;
  background: var(--surface);
  border: 1px solid var(--border2);
  border-radius: var(--radius-xs);
  cursor: pointer;
  color: var(--text2);
  font-size: 16px;
  display: flex; align-items: center; justify-content: center;
  transition: background .1s;
}
.btn-close:hover { background: var(--surface2); color: var(--text); }

.drawer-body { flex: 1; overflow: auto; padding: 18px 22px; display: flex; flex-direction: column; gap: 18px; }

/* ── TABS ── */
.tabs { display: flex; border-bottom: 1px solid var(--border); margin-bottom: -1px; }
.tab {
  padding: 10px 18px;
  font-size: 13px; cursor: pointer;
  color: var(--text3);
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
  transition: color .15s;
}
.tab.act { color: var(--green); border-bottom-color: var(--green); font-weight: 500; }
.tab:hover { color: var(--text); }
.tc { display: none; }
.tc.act { display: block; }

/* ── VALUES ── */
.pos { color: var(--green); font-family: var(--mono); }
.neg { color: var(--red);   font-family: var(--mono); }
.neutral { font-family: var(--mono); }

/* ── SPINNER ── */
@keyframes spin { to { transform: rotate(360deg); } }
.spinner {
  width: 20px; height: 20px;
  border: 2px solid var(--border2);
  border-top-color: var(--green);
  border-radius: 50%;
  animation: spin .7s linear infinite;
  display: inline-block;
  vertical-align: middle;
  margin-right: 8px;
}

/* ── EXPORT BTN ── */
.icon-btn {
  width: 32px; height: 32px;
  background: var(--surface);
  border: 1px solid var(--border2);
  border-radius: var(--radius-xs);
  cursor: pointer;
  color: var(--text2);
  font-size: 14px;
  display: flex; align-items: center; justify-content: center;
}
.icon-btn:hover { background: var(--surface2); color: var(--text); }

/* ── RESUMO VENDEDOR (cards no drawer) ── */
.d-kpis { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; }
.d-kpi {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 11px 14px;
}
.d-kpi-l { font-size: 10px; color: var(--text3); text-transform: uppercase; letter-spacing: 0.6px; margin-bottom: 4px; }
.d-kpi-v { font-size: 15px; font-family: var(--mono); }

/* ── SCROLLBAR ── */
::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: var(--bg); }
::-webkit-scrollbar-thumb { background: var(--surface3); border-radius: 99px; }
::-webkit-scrollbar-thumb:hover { background: var(--text3); }
</style>
</head>
<body>

<header>
  <div class="hd-left">
    <div class="hd-icon"><></div>
    <div>
      <div class="hd-title">Vendedores × Faturamento × Metas</div>
      <div class="hd-sub">GESTÃO COMERCIAL</div>
    </div>
  </div>
  <div class="hd-right">
    <span id="upd"></span>
  </div>
</header>

<div class="shell">

  <!-- SIDEBAR -->
  <aside>
    <div>
      <div class="flt-label">Período</div>
      <div class="flt-group">
        <div class="flt-row"><label>Data inicial</label><input type="date" id="fini"></div>
        <div class="flt-row"><label>Data final</label><input type="date" id="ffin"></div>
      </div>
    </div>

    <div class="divider"></div>

    <div>
      <div class="flt-label">Filtros</div>
      <div class="flt-group">
        <div class="flt-row">
          <label>Empresa</label>
          <select id="femp">
            <option value="0">Todas</option>
            <option value="1">Empresa 1</option>
            <option value="2">Empresa 2</option>
            <option value="3">Empresa 3</option>
          </select>
        </div>
        <div class="flt-row" style="position:relative;">
          <label>Vendedor</label>
          <input type="text" id="fvend" placeholder="Digite para buscar..." oninput="buscarVendedor(this.value)">
          <div id="fvend-list" style="position:absolute;top:100%;left:0;right:0;background:var(--surface);border:1px solid var(--border2);border-top:none;border-radius:0 0 var(--radius-sm) var(--radius-sm);max-height:200px;overflow-y:auto;display:none;z-index:100;"></div>
        </div>
        <div class="flt-row" style="position:relative;">
          <label>Gerente</label>
          <input type="text" id="fger" placeholder="Digite para buscar..." oninput="buscarGerente(this.value)">
          <div id="fger-list" style="position:absolute;top:100%;left:0;right:0;background:var(--surface);border:1px solid var(--border2);border-top:none;border-radius:0 0 var(--radius-sm) var(--radius-sm);max-height:200px;overflow-y:auto;display:none;z-index:100;"></div>
        </div>
      </div>
    </div>

    <button class="btn btn-primary" onclick="aplicar()"> Aplicar Filtros</button>
    <button class="btn btn-ghost" onclick="limpar()"> Limpar</button>

    <div class="divider" style="margin-top:auto;"></div>

    <div>
      <div class="flt-label">Exportar</div>
      <button class="btn btn-ghost" style="margin-top:6px;" onclick="exportCSV()">Exportar CSV</button>
    </div>
  </aside>

  <!-- MAIN -->
  <main>

    <!-- KPIs -->
    <div class="kpis">
      <div class="kpi g">
        <div class="kpi-label">Faturamento Bruto</div>
        <div class="kpi-val" id="k-fat">—</div>
        <div class="kpi-sub">soma do período</div>
        <div class="kpi-bar"></div>
      </div>
      <div class="kpi r">
        <div class="kpi-label">Total Devoluções</div>
        <div class="kpi-val" id="k-dev">—</div>
        <div class="kpi-sub">valor devolvido</div>
        <div class="kpi-bar"></div>
      </div>
      <div class="kpi b">
        <div class="kpi-label">Faturamento Líquido</div>
        <div class="kpi-val" id="k-liq">—</div>
        <div class="kpi-sub">fat - devol</div>
        <div class="kpi-bar"></div>
      </div>
      <div class="kpi a">
        <div class="kpi-label">Meta Total</div>
        <div class="kpi-val" id="k-met">—</div>
        <div class="kpi-sub">soma das metas</div>
        <div class="kpi-bar"></div>
      </div>
      <div class="kpi p">
        <div class="kpi-label">Margem Média</div>
        <div class="kpi-val" id="k-mg">—</div>
        <div class="kpi-sub">% lucro sobre fat</div>
        <div class="kpi-bar"></div>
      </div>
      <div class="kpi r">
        <div class="kpi-label">Qtd. Devoluções</div>
        <div class="kpi-val" id="k-qd">—</div>
        <div class="kpi-sub">notas devolvidas</div>
        <div class="kpi-bar"></div>
      </div>
    </div>

    <!-- CHARTS -->
    <div class="charts">
      <div class="chart-card">
        <div class="chart-title">Faturamento Líquido por Vendedor</div>
        <div style="position:relative;height:220px;"><canvas id="cBar"></canvas></div>
      </div>
      <div class="chart-card">
        <div class="chart-title">% Atingimento de Meta</div>
        <div style="position:relative;height:220px;"><canvas id="cDona"></canvas></div>
      </div>
    </div>

    <!-- TABLE -->
    <div class="tcard">
      <div class="tcard-head">
        <div style="display:flex;align-items:center;gap:10px;">
          <span class="tcard-title">Resumo por Vendedor</span>
          <span id="tcnt" style="font-size:11px;color:var(--text3);"></span>
        </div>
        <div style="display:flex;align-items:center;gap:8px;">
          <div class="srch-wrap">
            <span class="srch-ico"> </span>
            <input type="text" id="tsrch" placeholder="Filtrar vendedor..." oninput="renderTabela()">
          </div>
          <button class="icon-btn" title="Exportar CSV" onclick="exportCSV()">excel</button>
        </div>
      </div>

      <div class="twrap">
        <table>
          <thead>
            <tr>
              <th onclick="srt('codvend')">Cód</th>
              <th onclick="srt('apelido')">Vendedor</th>
              <th onclick="srt('faturamento')" style="text-align:right">Faturamento</th>
              <th onclick="srt('devolucao')" style="text-align:right">Devoluções</th>
              <th onclick="srt('fatu_liq')" style="text-align:right">Fat. Líquido</th>
              <th onclick="srt('met')" style="text-align:right">Meta</th>
              <th onclick="srt('pct_meta')">% Atingido</th>
              <th onclick="srt('margem')" style="text-align:right">Margem %</th>
              <th onclick="srt('cmv')" style="text-align:right">CMV</th>
              <th onclick="srt('custo_fixo')" style="text-align:right">Custo Fixo</th>
              <th onclick="srt('gastos_variaveis')" style="text-align:right">Gastos Var.</th>
              <th onclick="srt('qtd_devolucao')" style="text-align:right">Qtd.Dev</th>
            </tr>
          </thead>
          <tbody id="tbody-main">
            <tr><td colspan="12" class="loading-row">Selecione o período e aplique os filtros.</td></tr>
          </tbody>
        </table>
      </div>

      <div class="pag">
        <span id="pinfo"></span>
        <div class="pag-btns" id="pbts"></div>
      </div>
    </div>

  </main>
</div>

<!-- DRAWER DETALHE VENDEDOR -->
<div class="drawer-overlay" id="drawerOverlay" onclick="fecharDrawer(event)">
  <div class="drawer" onclick="event.stopPropagation()">
    <div class="drawer-head">
      <div>
        <div class="drawer-title" id="dr-title">Detalhe do Vendedor</div>
        <div class="drawer-sub"  id="dr-sub"></div>
      </div>
      <button class="btn-close" onclick="fecharDrawer()">x</button>
    </div>
    <div class="drawer-body">

      <!-- KPIs resumo vendedor -->
      <div class="d-kpis" id="d-kpis"></div>

      <!-- Abas -->
      <div>
        <div class="tabs">
          <div class="tab act" onclick="swtab(this,'dt-vendas')"> Vendas</div>
          <div class="tab"     onclick="swtab(this,'dt-dev')"> Devoluções</div>
        </div>

        <!-- Vendas detalhe -->
        <div id="dt-vendas" class="tc act">
          <div class="twrap" style="max-height:calc(100vh - 420px);overflow:auto;">
            <table>
              <thead>
                <tr>
                  <th>Nro Único</th>
                  <th>Cliente</th>
                  <th>Top</th>
                  <th style="text-align:right">Valor</th>
                  <th style="text-align:right">CMV</th>
                  <th style="text-align:right">Margem %</th>
                </tr>
              </thead>
              <tbody id="tbody-vendas">
                <tr><td colspan="6" class="loading-row">Carregando...</td></tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Devoluções detalhe -->
        <div id="dt-dev" class="tc">
          <div class="twrap" style="max-height:calc(100vh - 420px);overflow:auto;">
            <table>
              <thead>
                <tr>
                  <th>Nro Único</th>
                  <th>Cliente</th>
                  <th>Top</th>
                  <th style="text-align:right">Valor Dev.</th>
                </tr>
              </thead>
              <tbody id="tbody-dev">
                <tr><td colspan="4" class="loading-row">Carregando...</td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
/* ═══════════════════════════════════════
   GLOBALS
═══════════════════════════════════════ */
var ALL = [], FIL = [];
var sortC = 'fatu_liq', sortD = -1;
var pg = 1, PP = 15;
var cBar = null, cDona = null;
var CORES = ['#22c98e','#5b8af5','#f5a623','#e05c6e','#a78bfa','#38bdf8','#fb923c','#34d399','#f472b6','#60a5fa'];
var acTimerVend = null, acTimerGer = null;
var vendSelecionado = null, gerSelecionado = null;

/* ── Período padrão: 1º ao último dia do mês atual ── */
(function(){
  var h = new Date();
  var prim = new Date(h.getFullYear(), h.getMonth(), 1);
  var ult  = new Date(h.getFullYear(), h.getMonth() + 1, 0);
  function fmt(d){ return d.toISOString().split('T')[0]; }
  document.getElementById('fini').value = fmt(prim);
  document.getElementById('ffin').value = fmt(ult);
})();

/* ═══════════════════════════════════════
   FORMATOS
═══════════════════════════════════════ */
function brl(v){
  return 'R$ ' + (v||0).toLocaleString('pt-BR',{minimumFractionDigits:2, maximumFractionDigits:2});
}
function pct(v){
  return (v||0).toLocaleString('pt-BR',{minimumFractionDigits:2, maximumFractionDigits:2}) + '%';
}
function margClass(v){ return v >= 0 ? 'pos' : 'neg'; }

/* ═══════════════════════════════════════
   BUSCAR VENDEDOR (AUTOCOMPLETE)
═══════════════════════════════════════ */
function buscarVendedor(termo){
  clearTimeout(acTimerVend);
  var list = document.getElementById('fvend-list');
  
  // Se vazio, fechar lista e limpar seleção
  if(!termo || termo.length < 1){ 
    list.style.display = 'none'; 
    list.innerHTML = ''; 
    vendSelecionado = null;
    return; 
  }
  
  acTimerVend = setTimeout(function(){
    var like = '%' + termo.toUpperCase() + '%';
    var q = "SELECT CODVEND, APELIDO FROM TGFVEN " +
            "WHERE (UPPER(APELIDO) LIKE ? OR TO_CHAR(CODVEND) LIKE ?) " +
            "AND CODVEND <> 0 AND ROWNUM <= 15 AND ATIVO = 'S' ORDER BY APELIDO";
    var params = [{value:like,type:"S"},{value:like,type:"S"}];
    
    executeQuery(q, params, function(res){
      var dados = JSON.parse(res);
      if(!dados || dados.length===0){
        list.innerHTML='<div style="padding:8px 12px;color:var(--text3);font-size:12px;">Nenhum vendedor encontrado</div>';
        list.style.display='block'; 
        return;
      }
      
      list.innerHTML = dados.map(function(v){
        var apelido = (v.APELIDO||'').replace(/"/g,'&quot;');
        return '<div style="padding:8px 12px;cursor:pointer;border-bottom:1px solid var(--border);font-size:12px;" ' +
               'onclick="selecionarVendedor('+v.CODVEND+',\''+apelido.replace(/'/g,"\\'")+'\')" ' +
               'onmouseover="this.style.background=\'var(--surface2)\'" ' +
               'onmouseout="this.style.background=\'transparent\'">'+
               '<strong>'+v.CODVEND+'</strong> - '+v.APELIDO+'</div>';
      }).join('');
      list.style.display='block';
    }, function(err){
      list.innerHTML='<div style="padding:8px 12px;color:var(--red);font-size:12px;">Erro: '+err+'</div>';
      list.style.display='block';
    });
  }, 300);
}

function selecionarVendedor(codvend, apelido){
  document.getElementById('fvend').value = apelido + ' (' + codvend + ')';
  vendSelecionado = codvend;
  document.getElementById('fvend-list').style.display = 'none';
}

/* ═══════════════════════════════════════
   BUSCAR GERENTE (AUTOCOMPLETE)
═══════════════════════════════════════ */
function buscarGerente(termo){
  clearTimeout(acTimerGer);
  var list = document.getElementById('fger-list');
  
  // Se vazio, fechar lista e limpar seleção
  if(!termo || termo.length < 1){ 
    list.style.display = 'none'; 
    list.innerHTML = ''; 
    gerSelecionado = null;
    return; 
  }
  
  acTimerGer = setTimeout(function(){
    var like = '%' + termo.toUpperCase() + '%';
    var q = "SELECT CODVEND, APELIDO FROM TGFVEN " +
            "WHERE (UPPER(APELIDO) LIKE ? OR TO_CHAR(CODVEND) LIKE ?) " +
            "AND CODVEND <> 0 AND ROWNUM <= 15 AND ATIVO = 'S' AND TIPVEND IN ('G', 'S') ORDER BY APELIDO";
    var params = [{value:like,type:"S"},{value:like,type:"S"}];
    
    executeQuery(q, params, function(res){
      var dados = JSON.parse(res);
      if(!dados || dados.length===0){
        list.innerHTML='<div style="padding:8px 12px;color:var(--text3);font-size:12px;">Nenhum gerente encontrado</div>';
        list.style.display='block'; 
        return;
      }
      
      list.innerHTML = dados.map(function(g){
        var apelido = (g.APELIDO||'').replace(/"/g,'&quot;');
        return '<div style="padding:8px 12px;cursor:pointer;border-bottom:1px solid var(--border);font-size:12px;" ' +
               'onclick="selecionarGerente('+g.CODVEND+',\''+apelido.replace(/'/g,"\\'")+'\')" ' +
               'onmouseover="this.style.background=\'var(--surface2)\'" ' +
               'onmouseout="this.style.background=\'transparent\'">'+
               '<strong>'+g.CODVEND+'</strong> - '+g.APELIDO+'</div>';
      }).join('');
      list.style.display='block';
    }, function(err){
      list.innerHTML='<div style="padding:8px 12px;color:var(--red);font-size:12px;">Erro: '+err+'</div>';
      list.style.display='block';
    });
  }, 300);
}

function selecionarGerente(codger, apelido){
  document.getElementById('fger').value = apelido + ' (' + codger + ')';
  gerSelecionado = codger;
  document.getElementById('fger-list').style.display = 'none';
}

/* ═══════════════════════════════════════
   QUERY PRINCIPAL — RESUMO POR VENDEDOR
═══════════════════════════════════════ */
var SQL_MAIN =
"WITH BASE AS ( " +
"  SELECT " +
"      cab.nunota, " +
"      cab.codvend, " +
"      ven.apelido, " +
"      ven.codger, " +
"      g.apelido as gerente, " +
"      cab.codtipoper, " +
"      count(case when cab.tipmov = 'D' then cab.nunota end) as QTD_DEVOLUCAO, " +
"      SUM( CASE WHEN CAB.CODTIPOPER IN ( " +
"              SELECT CODTIPOPER FROM TGFTOP T " +
"              WHERE T.ATUALCOM = 'C' AND T.TIPMOV = 'V' " +
"              AND T.DHALTER = (SELECT MAX(T2.DHALTER) FROM TGFTOP T2 WHERE T2.CODTIPOPER = T.CODTIPOPER) " +
"          ) THEN CAB.VLRNOTA ELSE 0 END ) AS VLR_BRU, " +
"      SUM( CASE " +
"          WHEN CAB.CODTIPOPER IN ( " +
"              SELECT CODTIPOPER FROM TGFTOP T WHERE T.ATUALCOM='C' AND T.TIPMOV='V' " +
"              AND T.DHALTER=(SELECT MAX(T2.DHALTER) FROM TGFTOP T2 WHERE T2.CODTIPOPER=T.CODTIPOPER)) " +
"          THEN CAB.VLRNOTA " +
"          WHEN CAB.CODTIPOPER IN ( " +
"              SELECT CODTIPOPER FROM TGFTOP T WHERE T.ATUALCOM='C' AND T.TIPMOV='D' " +
"              AND T.DHALTER=(SELECT MAX(T2.DHALTER) FROM TGFTOP T2 WHERE T2.CODTIPOPER=T.CODTIPOPER)) " +
"          THEN -CAB.VLRNOTA " +
"          ELSE 0 END ) AS VLR_LIQ " +
"  FROM tgfcab cab " +
"  JOIN tgfven ven ON ven.codvend = cab.codvend " +
"  LEFT JOIN tgfven g ON g.codvend = ven.codger " +
"  WHERE (cab.codemp = ? OR ? = 0) " +
"    AND CAB.STATUSNOTA = 'L' " +
"    AND cab.dtneg BETWEEN ? AND ? " +
"    AND (cab.codvend = ? OR ? = 0) " +
"    AND ((ven.codger = ? OR ven.codger IS NULL) OR ? = 0) " +
"    AND CAB.TIPMOV IN ('V', 'D') " +
"  GROUP BY cab.nunota, cab.codvend, ven.apelido, ven.codger, g.apelido, cab.codtipoper " +
"), " +
"MARGEM AS ( " +
"    SELECT CAB.CODVEND, CAB.NUNOTA, " +
"        CAB.VLRNOTA * MAX(TOP.GOLDEV) AS FATURAMENTO_MARGEM, " +
"        SUM((ITE.AD_CUSTOUTILIZADO * ITE.QTDNEG) * TOP.GOLDEV) AS CMV, " +
"        (COALESCE(MAX(ITE.AD_DESPENCARGOS),0)) AS CUSTO_FIXO, " +
"        AD_GET_CUSTO_VAR_NOTA_2(CAB.NUNOTA) * MAX(TOP.GOLDEV) AS GASTOS_VARIAVEIS " +
"    FROM TGFCAB CAB " +
"    JOIN TGFITE ITE ON CAB.NUNOTA = ITE.NUNOTA " +
"    INNER JOIN TGFTOP TOP ON TOP.CODTIPOPER = CAB.CODTIPOPER " +
"        AND TOP.DHALTER = (SELECT MAX(T2.DHALTER) FROM TGFTOP T2 WHERE T2.CODTIPOPER = CAB.CODTIPOPER) " +
"    JOIN tgfven ven ON ven.codvend = cab.codvend " +
"    LEFT JOIN tgfven g ON g.codvend = ven.codger " +
"    WHERE (cab.codemp = ? OR ? = 0) " +
"    AND CAB.STATUSNOTA = 'L' " +
"    AND TOP.ATUALCOM = 'C' " +
"    AND cab.dtneg BETWEEN ? AND ? " +
"    AND (cab.codvend = ? OR ? = 0) " +
"    AND ((ven.codger = ? OR ven.codger IS NULL) OR ? = 0) " +
"    GROUP BY CAB.NUNOTA, CAB.VLRNOTA, CAB.CODVEND " +
") " +
"SELECT " +
"  b.codvend, b.apelido, b.gerente, " +
"  SUM(CASE WHEN b.codtipoper IN (SELECT codtipoper FROM tgftop WHERE atualcom='C' AND tipmov='V') THEN b.vlr_bru ELSE 0 END) AS faturamento, " +
"  SUM(CASE WHEN b.codtipoper IN (SELECT codtipoper FROM tgftop WHERE atualcom='C' AND tipmov='D') THEN b.vlr_liq ELSE 0 END) AS devolucao, " +
"  SUM(b.vlr_liq) AS fatu_liq, " +
"  (SELECT NVL(SUM(met.prevrec),0) FROM tgfmet met WHERE met.codvend = b.codvend AND met.dtref BETWEEN ? AND ?) AS met, " +
"  MG.CMV, MG.FATURAMENTO_MARGEM, MG.GASTOS_VARIAVEIS, " +
"  MG.CUSTO_FIXO AS CUSTO_FIXO, " +
"  ((MG.FATURAMENTO_MARGEM - MG.CMV - MG.GASTOS_VARIAVEIS) - MG.CUSTO_FIXO) / NULLIF(MG.FATURAMENTO_MARGEM, 0) * 100.0 AS PERC_LUCRO," +
"  SUM(CASE WHEN b.codtipoper IN (SELECT codtipoper FROM tgftop WHERE tipmov='D' AND atualcom='C') THEN 1 ELSE 0 END) AS qtd_devolucao " +
"FROM BASE b " +
"LEFT JOIN ( " +
"    SELECT CODVEND, " +
"        SUM(CMV) AS CMV, " +
"        SUM(FATURAMENTO_MARGEM) AS FATURAMENTO_MARGEM, " +
"        SUM(GASTOS_VARIAVEIS) AS GASTOS_VARIAVEIS, " +
"        SUM(FATURAMENTO_MARGEM * (CUSTO_FIXO / 100)) AS CUSTO_FIXO " +
"    FROM MARGEM GROUP BY CODVEND " +
") MG ON MG.CODVEND = B.CODVEND " +
"GROUP BY b.codvend, b.apelido, b.gerente, MG.CMV, MG.FATURAMENTO_MARGEM, MG.GASTOS_VARIAVEIS, MG.CUSTO_FIXO " +
"ORDER BY fatu_liq DESC";

/* ═══════════════════════════════════════
   QUERY DETALHE VENDAS
═══════════════════════════════════════ */
var SQL_VENDAS =
"WITH BASE AS ( " +
"    SELECT cab.nunota, cab.codvend, ven.apelido, cab.codparc, par.razaosocial, " +
"        cab.codtipoper, tpo.descroper, " +
"        CASE WHEN CAB.CODTIPOPER IN ( " +
"            SELECT CODTIPOPER FROM TGFTOP T WHERE T.ATUALCOM='C' AND T.TIPMOV='V' " +
"            AND T.DHALTER=(SELECT MAX(T2.DHALTER) FROM TGFTOP T2 WHERE T2.CODTIPOPER=T.CODTIPOPER) " +
"        ) THEN CAB.VLRNOTA ELSE 0 END AS vlr_liq " +
"    FROM tgfcab cab " +
"    JOIN tgfven ven ON ven.codvend = cab.codvend " +
"    JOIN tgfpar par ON par.codparc = cab.codparc " +
"    JOIN tgftop tpo ON tpo.codtipoper = cab.codtipoper " +
"        AND tpo.dhalter = cab.dhtipoper AND tpo.golsinal = -1 " +
"    WHERE cab.statusnota='L' " +
"    AND (cab.codemp = ? OR ? = 0) " +
"    AND cab.dtneg BETWEEN ? AND ? " +
"    AND cab.codvend = ? " +
"    AND EXISTS (SELECT 1 FROM tgfite ite WHERE ite.nunota=cab.nunota AND NVL(ite.usoprod,' ')<>'D') " +
"), " +
"MARGEM AS ( " +
"    SELECT CAB.CODVEND, CAB.NUNOTA, " +
"        CAB.VLRNOTA * MAX(TOP.GOLDEV) AS FATURAMENTO_MARGEM, " +
"        SUM((ITE.AD_CUSTOUTILIZADO * ITE.QTDNEG) * TOP.GOLDEV) AS CMV, " +
"        (COALESCE(MAX(ITE.AD_DESPENCARGOS),0)) AS CUSTO_FIXO, " +
"        (COALESCE(MAX(ITE.AD_COMVENDA),0)) AS COMISSAO, " +
"        AD_GET_CUSTO_VAR_NOTA_2(CAB.NUNOTA) * MAX(TOP.GOLDEV) AS GASTOS_VARIAVEIS " +
"    FROM TGFCAB CAB " +
"    JOIN TGFITE ITE ON CAB.NUNOTA = ITE.NUNOTA " +
"    INNER JOIN TGFTOP TOP ON TOP.CODTIPOPER=CAB.CODTIPOPER " +
"        AND TOP.DHALTER=(SELECT MAX(T2.DHALTER) FROM TGFTOP T2 WHERE T2.CODTIPOPER=CAB.CODTIPOPER) " +
"    WHERE cab.statusnota='L' " +
"    AND (cab.codemp = ? OR ? = 0) " +
"    AND cab.dtneg BETWEEN ? AND ? " +
"    AND cab.codvend = ? " +
"    AND CAB.CODTIPOPER IN (SELECT CODTIPOPER FROM TGFTOP WHERE ATUALCOM='C' AND TIPMOV IN ('V','D')) " +
"    GROUP BY CAB.NUNOTA, CAB.VLRNOTA, CAB.CODVEND " +
") " +
"SELECT b.nunota, b.apelido, b.codparc, b.razaosocial, b.codtipoper, b.vlr_liq, b.descroper, " +
"    mg.faturamento_margem, mg.cmv, " +
"    mg.custo_fixo, " +
"    mg.comissao, mg.gastos_variaveis, " +
"    mg.faturamento_margem - mg.cmv - mg.custo_fixo - mg.gastos_variaveis AS lucro, " +
"    NVL((mg.faturamento_margem - mg.cmv - mg.custo_fixo - mg.gastos_variaveis) / mg.faturamento_margem * 100, 0) AS perc_lucro " +
"FROM BASE b " +
"JOIN margem mg ON mg.nunota = b.nunota " +
"ORDER BY b.vlr_liq DESC";

/* ═══════════════════════════════════════
   QUERY DETALHE DEVOLUÇÕES
═══════════════════════════════════════ */
var SQL_DEV =
"WITH BASE AS ( " +
"    SELECT cab.nunota, cab.codvend, ven.apelido, cab.codparc, par.razaosocial, " +
"        cab.codtipoper, tpo.descroper, " +
"        (cab.vlrnota - cab.vlripi - cab.vlrsubst) AS vlr_liq " +
"    FROM tgfcab cab " +
"    JOIN tgfven ven ON ven.codvend = cab.codvend " +
"    JOIN tgfpar par ON par.codparc = cab.codparc " +
"    JOIN tgftop tpo ON tpo.codtipoper=cab.codtipoper " +
"        AND tpo.dhalter=cab.dhtipoper AND tpo.golsinal=-1 " +
"    WHERE cab.statusnota='L' AND cab.tipmov='D' " +
"    AND (cab.codemp = ? OR ? = 0) " +
"    AND cab.dtneg BETWEEN ? AND ? " +
"    AND cab.codvend = ? " +
"    AND EXISTS (SELECT 1 FROM tgfite ite WHERE ite.nunota=cab.nunota AND NVL(ite.usoprod,' ')<>'D') " +
") " +
"SELECT b.nunota, b.codvend, b.apelido, b.codparc, b.razaosocial, " +
"    b.codtipoper, b.vlr_liq, b.descroper " +
"FROM BASE b ORDER BY b.vlr_liq DESC";

/* ═══════════════════════════════════════
   APLICAR FILTROS
═══════════════════════════════════════ */
function aplicar(){
  var ini = document.getElementById('fini').value;
  var fim = document.getElementById('ffin').value;
  if(!ini || !fim){ alert('Informe as datas de início e fim.'); return; }

  var emp  = parseInt(document.getElementById('femp').value) || 0;
  var vend = vendSelecionado || 0;
  var ger  = gerSelecionado || 0;

  document.getElementById('upd').innerHTML = '<span class="spinner"></span> Carregando...';
  document.getElementById('tbody-main').innerHTML = '<tr><td colspan="12" class="loading-row"><span class="spinner"></span> Buscando dados...</td></tr>';

  var p = [
    // BASE
    {value:emp,  type:"I"},{value:emp,  type:"I"},
    {value:ini+" 00:00:00",type:"D"},{value:fim+" 23:59:59",type:"D"},
    {value:vend, type:"I"},{value:vend, type:"I"},
    {value:ger,  type:"I"},{value:ger,  type:"I"},
    // MARGEM
    {value:emp,  type:"I"},{value:emp,  type:"I"},
    {value:ini+" 00:00:00",type:"D"},{value:fim+" 23:59:59",type:"D"},
    {value:vend, type:"I"},{value:vend, type:"I"},
    {value:ger,  type:"I"},{value:ger,  type:"I"},
    // meta subquery
    {value:ini+" 00:00:00",type:"D"},{value:fim+" 23:59:59",type:"D"}
  ];

  executeQuery(SQL_MAIN, p, function(res){
    var d = JSON.parse(res);
    document.getElementById('upd').textContent = 'Atualizado ' + new Date().toLocaleTimeString('pt-BR');

    if(!d || d.length === 0){
      ALL = []; FIL = [];
      document.getElementById('tbody-main').innerHTML = '<tr><td colspan="12" class="loading-row">Nenhum dado encontrado.</td></tr>';
      atualizarKPIs(); return;
    }

    ALL = d.map(function(r){
      var fat   = parseFloat(r.FATURAMENTO)        || 0;
      var dev   = parseFloat(r.DEVOLUCAO)          || 0;
      var liq   = parseFloat(r.FATU_LIQ)           || 0;
      var met   = parseFloat(r.MET)                || 0;
      var mg    = parseFloat(r.PERC_LUCRO)         || 0;
      var cmv   = parseFloat(r.CMV)                || 0;
      var cf    = parseFloat(r.CUSTO_FIXO)         || 0;
      var gv    = parseFloat(r.GASTOS_VARIAVEIS)   || 0;
      var qdv   = parseInt(r.QTD_DEVOLUCAO)        || 0;
      var pMet  = met ? (liq / met * 100) : 0;
      return {
        codvend: r.CODVEND, apelido: r.APELIDO || '—', gerente: r.GERENTE || '—',
        faturamento: fat, devolucao: dev, fatu_liq: liq,
        met: met, margem: mg, cmv: cmv, custo_fixo: cf,
        gastos_variaveis: gv, qtd_devolucao: qdv, pct_meta: pMet
      };
    });

    FIL = ALL.slice(); pg = 1;
    atualizarKPIs();
    renderTabela();
    renderGraficos();

  }, function(err){
    document.getElementById('upd').textContent = 'Erro';
    alert('Erro ao carregar:\n' + err);
  });
}

/* ═══════════════════════════════════════
   KPIs
═══════════════════════════════════════ */
function atualizarKPIs(){
  var fat = FIL.reduce(function(s,r){ return s+r.faturamento; },0);
  var dev = FIL.reduce(function(s,r){ return s+r.devolucao; },0);
  var liq = FIL.reduce(function(s,r){ return s+r.fatu_liq; },0);
  var met = FIL.reduce(function(s,r){ return s+r.met; },0);
  var qd  = FIL.reduce(function(s,r){ return s+r.qtd_devolucao; },0);
  var mg  = fat ? (FIL.reduce(function(s,r){ return s+(r.margem*r.faturamento); },0)/fat) : 0;
  document.getElementById('k-fat').textContent = brl(fat);
  document.getElementById('k-dev').textContent = brl(Math.abs(dev));
  document.getElementById('k-liq').textContent = brl(liq);
  document.getElementById('k-met').textContent = brl(met);
  document.getElementById('k-mg').textContent  = pct(mg);
  document.getElementById('k-qd').textContent  = qd;
}

/* ═══════════════════════════════════════
   TABELA
═══════════════════════════════════════ */
function renderTabela(){
  var busca = (document.getElementById('tsrch').value||'').toLowerCase();
  var d = FIL.filter(function(r){
    return !busca || r.apelido.toLowerCase().indexOf(busca) >= 0 ||
           String(r.codvend).indexOf(busca) >= 0;
  });

  d.sort(function(a,b){
    var va=a[sortC], vb=b[sortC];
    if(typeof va==='number') return sortD*(va-vb);
    return sortD*String(va).localeCompare(String(vb),'pt-BR');
  });

  var tot = d.length, totP = Math.ceil(tot/PP)||1;
  if(pg > totP) pg = totP;
  var pag = d.slice((pg-1)*PP, pg*PP);

  document.getElementById('tcnt').textContent = tot + ' vendedor(es)';
  document.getElementById('pinfo').textContent = 'Pág '+pg+'/'+totP+' ('+tot+' registros)';

  /* atualizar classes sort nos headers */
  document.querySelectorAll('thead th').forEach(function(th){
    th.classList.remove('sort-asc','sort-desc');
  });

  var tb = document.getElementById('tbody-main');
  if(pag.length === 0){
    tb.innerHTML = '<tr><td colspan="12" class="loading-row">Nenhum registro.</td></tr>';
  } else {
    tb.innerHTML = pag.map(function(r){
      var pMet  = r.pct_meta;
      var pFill = Math.min(100, Math.max(0, pMet));
      var pClr  = pMet >= 100 ? '#22c98e' : pMet >= 70 ? '#f5a623' : '#e05c6e';
      var mCls  = margClass(r.margem);
      return '<tr onclick="abrirDetalhe('+r.codvend+',\''+r.apelido.replace(/'/g,"\\'")+'\')">' +
        '<td><span class="neutral">'+r.codvend+'</span></td>' +
        '<td><strong>'+r.apelido+'</strong></td>' +
        '<td style="text-align:right"><span class="pos">'+brl(r.faturamento)+'</span></td>' +
        '<td style="text-align:right"><span class="neg">'+brl(Math.abs(r.devolucao))+'</span></td>' +
        '<td style="text-align:right"><strong><span class="'+margClass(r.fatu_liq)+'">'+brl(r.fatu_liq)+'</span></strong></td>' +
        '<td style="text-align:right"><span class="neutral">'+brl(r.met)+'</span></td>' +
        '<td>' +
          '<div class="prog-wrap">' +
          '<div class="prog-bar"><div class="prog-fill" style="width:'+pFill+'%;background:'+pClr+'"></div></div>' +
          '<span class="prog-pct" style="color:'+pClr+'">'+pMet.toFixed(1)+'%</span>' +
          '</div>' +
        '</td>' +
        '<td style="text-align:right"><strong><span class="'+mCls+'">'+pct(r.margem)+'</span></strong></td>' +
        '<td style="text-align:right"><span class="neutral">'+brl(r.cmv)+'</span></td>' +
        '<td style="text-align:right"><span class="neutral">'+brl(r.custo_fixo)+'</span></td>' +
        '<td style="text-align:right"><span class="neutral">'+brl(r.gastos_variaveis)+'</span></td>' +
        '<td style="text-align:right">' +
          '<span class="badge '+(r.qtd_devolucao>0?'badge-r':'badge-g')+'">'+r.qtd_devolucao+'</span>' +
        '</td>' +
      '</tr>';
    }).join('');
  }

  renderPag(totP);
}

function renderPag(tot){
  var el = document.getElementById('pbts');
  var html = '';
  for(var i=1;i<=tot;i++){
    html += '<button class="pb'+(i===pg?' act':'')+'" onclick="irPag('+i+')">'+i+'</button>';
  }
  el.innerHTML = html;
}
function irPag(n){ pg=n; renderTabela(); }

function srt(col){
  if(sortC===col) sortD*=-1; else { sortC=col; sortD=-1; }
  renderTabela();
}

/* ═══════════════════════════════════════
   GRÁFICOS
═══════════════════════════════════════ */
function renderGraficos(){
  var d = FIL.slice().sort(function(a,b){ return b.fatu_liq - a.fatu_liq; }).slice(0,10);
  var labels = d.map(function(r){ return r.apelido.split('.')[0]; });
  var vals   = d.map(function(r){ return r.fatu_liq; });
  var cores  = d.map(function(r,i){ return r.fatu_liq >= 0 ? CORES[i%CORES.length] : '#e05c6e'; });

  var cfg = {
    responsive:true, maintainAspectRatio:false,
    plugins:{ legend:{ display:false }, tooltip:{ callbacks:{
      label: function(c){ return ' '+brl(c.raw); }
    }}},
    scales:{
      x:{ ticks:{color:'#5a607a',font:{size:10}}, grid:{color:'rgba(255,255,255,0.04)'} },
      y:{ ticks:{color:'#5a607a',font:{size:10},callback:function(v){ return 'R$'+v.toLocaleString('pt-BR'); }},
           grid:{color:'rgba(255,255,255,0.04)'} }
    }
  };

  if(cBar) cBar.destroy();
  cBar = new Chart(document.getElementById('cBar'),{
    type:'bar',
    data:{ labels:labels, datasets:[{ data:vals, backgroundColor:cores, borderRadius:5, borderSkipped:false }] },
    options: cfg
  });

  var meta  = FIL.reduce(function(s,r){ return s+r.met; }, 0);
  var liq   = FIL.reduce(function(s,r){ return s+Math.max(0,r.fatu_liq); }, 0);
  var resto = Math.max(0, meta - liq);
  if(cDona) cDona.destroy();
  cDona = new Chart(document.getElementById('cDona'),{
    type:'doughnut',
    data:{
      labels:['Realizado','Meta restante'],
      datasets:[{ data:[liq, resto],
        backgroundColor:['#22c98e','#2c3049'],
        borderColor:['#22c98e','#3c4060'],
        borderWidth:1 }]
    },
    options:{
      responsive:true, maintainAspectRatio:false, cutout:'72%',
      plugins:{
        legend:{ position:'bottom', labels:{ color:'#9096b0', boxWidth:10, font:{size:11} } },
        tooltip:{ callbacks:{ label:function(c){ return ' '+brl(c.raw); } } }
      }
    }
  });
}

/* ═══════════════════════════════════════
   DRAWER — DETALHE VENDEDOR
═══════════════════════════════════════ */
function abrirDetalhe(codvend, apelido){
  document.getElementById('dr-title').textContent = apelido;
  document.getElementById('dr-sub').textContent   = 'Cód. ' + codvend + ' · período selecionado';
  document.getElementById('tbody-vendas').innerHTML = '<tr><td colspan="6" class="loading-row"><span class="spinner"></span> Carregando...</td></tr>';
  document.getElementById('tbody-dev').innerHTML    = '<tr><td colspan="4" class="loading-row"><span class="spinner"></span> Carregando...</td></tr>';

  /* KPIs do vendedor a partir do resumo */
  var rv = ALL.filter(function(r){ return r.codvend == codvend; })[0] || {};
  document.getElementById('d-kpis').innerHTML = [
    {l:'Faturamento',  v:brl(rv.faturamento||0),      cls:'pos'},
    {l:'Devoluções',   v:brl(Math.abs(rv.devolucao||0)), cls:'neg'},
    {l:'Fat. Líquido', v:brl(rv.fatu_liq||0),          cls: (rv.fatu_liq||0)>=0?'pos':'neg'},
    {l:'Margem %',     v:pct(rv.margem||0),             cls: (rv.margem||0)>=0?'pos':'neg'}
  ].map(function(k){
    return '<div class="d-kpi"><div class="d-kpi-l">'+k.l+'</div><div class="d-kpi-v '+k.cls+'">'+k.v+'</div></div>';
  }).join('');

  document.getElementById('drawerOverlay').classList.add('open');

  var ini  = document.getElementById('fini').value;
  var fim  = document.getElementById('ffin').value;
  var emp  = parseInt(document.getElementById('femp').value)||0;

  /* Vendas detalhe */
  var pV = [
    {value:emp,type:"I"},{value:emp,type:"I"},
    {value:ini+" 00:00:00",type:"D"},{value:fim+" 23:59:59",type:"D"},
    {value:codvend,type:"I"},
    {value:emp,type:"I"},{value:emp,type:"I"},
    {value:ini+" 00:00:00",type:"D"},{value:fim+" 23:59:59",type:"D"},
    {value:codvend,type:"I"}
  ];
  executeQuery(SQL_VENDAS, pV, function(res){
    var d = JSON.parse(res);
    if(!d||d.length===0){
      document.getElementById('tbody-vendas').innerHTML='<tr><td colspan="6" class="loading-row">Sem vendas no período.</td></tr>';
      return;
    }
    document.getElementById('tbody-vendas').innerHTML = d.map(function(r){
      var mg = parseFloat(r.PERC_LUCRO)||0;
      return '<tr>'+
        '<td><strong style="color:var(--blue);cursor:pointer" onclick="abrirNota('+r.NUNOTA+')">'+r.NUNOTA+'</strong></td>'+
        '<td>'+r.RAZAOSOCIAL+'</td>'+
        '<td><span class="badge badge-b">'+r.DESCROPER+'</span></td>'+
        '<td style="text-align:right"><span class="pos">'+brl(parseFloat(r.VLR_LIQ)||0)+'</span></td>'+
        '<td style="text-align:right"><span class="neutral">'+brl(parseFloat(r.CMV)||0)+'</span></td>'+
        '<td style="text-align:right"><span class="'+margClass(mg)+'">'+pct(mg)+'</span></td>'+
      '</tr>';
    }).join('');
  }, function(err){ alert('Erro vendas:\n'+err); });

  /* Devoluções detalhe */
  var pD = [
    {value:emp,type:"I"},{value:emp,type:"I"},
    {value:ini+" 00:00:00",type:"D"},{value:fim+" 23:59:59",type:"D"},
    {value:codvend,type:"I"}
  ];
  executeQuery(SQL_DEV, pD, function(res){
    var d = JSON.parse(res);
    if(!d||d.length===0){
      document.getElementById('tbody-dev').innerHTML='<tr><td colspan="4" class="loading-row">Sem devoluções no período.</td></tr>';
      return;
    }
    document.getElementById('tbody-dev').innerHTML = d.map(function(r){
      return '<tr>'+
        '<td><strong style="color:var(--blue);cursor:pointer" onclick="abrirNota('+r.NUNOTA+')">'+r.NUNOTA+'</strong></td>'+
        '<td>'+r.RAZAOSOCIAL+'</td>'+
        '<td><span class="badge badge-r">'+r.DESCROPER+'</span></td>'+
        '<td style="text-align:right"><span class="neg">'+brl(parseFloat(r.VLR_LIQ)||0)+'</span></td>'+
      '</tr>';
    }).join('');
  }, function(err){ alert('Erro devoluções:\n'+err); });
}

function fecharDrawer(e){
  if(e && e.target !== document.getElementById('drawerOverlay')) return;
  document.getElementById('drawerOverlay').classList.remove('open');
}

/* ═══════════════════════════════════════
   ABAS DRAWER
═══════════════════════════════════════ */
function swtab(el, id){
  document.querySelectorAll('.tab').forEach(function(t){ t.classList.remove('act'); });
  document.querySelectorAll('.tc').forEach(function(t){ t.classList.remove('act'); });
  el.classList.add('act');
  document.getElementById(id).classList.add('act');
}

/* ═══════════════════════════════════════
   LIMPAR
═══════════════════════════════════════ */
function limpar(){
  document.getElementById('femp').value  = '0';
  document.getElementById('fvend').value = '';
  document.getElementById('fvend-list').style.display = 'none';
  document.getElementById('fger').value = '';
  document.getElementById('fger-list').style.display = 'none';
  vendSelecionado = null;
  gerSelecionado = null;
}

/* ═══════════════════════════════════════
   EXPORTAR CSV
═══════════════════════════════════════ */
function exportCSV(){
  if(!FIL.length){ alert('Sem dados para exportar.'); return; }
  var esc = function(v){ return '"'+String(v==null?'':v).replace(/"/g,'""')+'"'; };
  var S = ';';
  var h = ['Cod','Vendedor','Faturamento','Devoluções','Fat.Líquido','Meta','%Meta','Margem%','CMV','CustoFixo','GastosVar.','Qtd.Dev'];
  var rows = FIL.map(function(r){
    return [r.codvend, r.apelido,
      r.faturamento.toFixed(2), r.devolucao.toFixed(2), r.fatu_liq.toFixed(2),
      r.met.toFixed(2), r.pct_meta.toFixed(2), r.margem.toFixed(2),
      r.cmv.toFixed(2), r.custo_fixo.toFixed(2), r.gastos_variaveis.toFixed(2),
      r.qtd_devolucao].map(esc).join(S);
  });
  var csv = 'sep=;\r\n'+h.map(esc).join(S)+'\r\n'+rows.join('\r\n');
  var blob = new Blob(['\uFEFF'+csv],{type:'text/csv;charset=utf-8;'});
  var url = URL.createObjectURL(blob);
  var a = document.createElement('a'); a.href=url; a.download='vendedores_faturamento.csv';
  a.style.display='none'; document.body.appendChild(a); a.click();
  document.body.removeChild(a); URL.revokeObjectURL(url);
}

/* ═══════════════════════════════════════
   ABRIR NOTA (Sankhya)
═══════════════════════════════════════ */
function abrirNota(nunota){
  openApp('br.com.sankhya.com.mov.CentralNotas',{ NUNOTA: nunota });
}
</script>
</body>
</html>
