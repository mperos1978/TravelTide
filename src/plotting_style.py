import seaborn as sns
import plotly.express as px


# shared colors
COLORS = {
    "blue": "#6699CC",
    "lavender": "#BB88AA",
    "mint": "#66AA99",
    "ice": "#B9DDE8",
    "orange": "#DDAA66",
    "highlight": "#886699",
    "text": "#263445",
    "background": "#F5F7FB",
    "table_header": "#DCE6F1",
}

PALETTE = [
    COLORS["blue"],
    COLORS["lavender"],
    COLORS["mint"],
    COLORS["orange"],
]

GENDER_COLORS = {
    "F": COLORS["lavender"],
    "M": COLORS["blue"],
    "O": COLORS["mint"],
}


# apply shared chart settings
def apply_plot_style():
    sns.set_theme(
        style="whitegrid",
        palette=PALETTE,
        rc={
            "font.family": "DejaVu Sans",
            "figure.facecolor": COLORS["background"],
            "axes.facecolor": COLORS["background"],
            "text.color": COLORS["text"],
            "axes.labelcolor": COLORS["text"],
            "xtick.color": COLORS["text"],
            "ytick.color": COLORS["text"],
            "grid.color": "#DDE3EC",
            "axes.spines.top": False,
            "axes.spines.right": False,
        },
    )

    px.defaults.template = "plotly_white"
    px.defaults.color_discrete_sequence = PALETTE

# format overview tables without changing their data
def style_overview(df, title, formats=None):
    return (
        df.style
        .hide(axis="index")
        .set_caption(title)
        .format(formats or {}, na_rep="—")
        .set_table_attributes(
            'style="border-collapse:collapse;'
            'font-family:Segoe UI,sans-serif;"'
        )
        .set_table_styles([
            {
                "selector": "caption",
                "props": [
                    ("color", COLORS["ice"]),
                    ("font-size", "18px"),
                    ("font-weight", "700"),
                    ("text-align", "left"),
                    ("padding", "12px 0"),
                ],
            },
            {
                "selector": "th",
                "props": [
                    ("background-color", COLORS["table_header"]),
                    ("color", COLORS["text"]),
                    ("padding", "10px 14px"),
                    ("text-align", "left"),
                ],
            },
            {
                "selector": "td",
                "props": [
                    ("background-color", COLORS["background"]),
                    ("color", COLORS["text"]),
                    ("padding", "8px 14px"),
                    ("border-bottom", "1px solid #DDE3EC"),
                ],
            },
        ])
    )