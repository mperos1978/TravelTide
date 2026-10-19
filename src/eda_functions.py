import pandas as pd
import matplotlib.pyplot as plt

from IPython.display import HTML, display

from .plotting_style import COLORS, style_overview


def raw_data_overview(df, name, key=None, preview_rows=5):
    """Display a raw-data overview without modifying the DataFrame."""

    if key is not None and key not in df.columns:
        raise KeyError(f"Key column not found: {key}")

    # summarize table size and completely duplicated rows
    summary = pd.DataFrame({
        "metric": [
            "Rows",
            "Columns",
            "Duplicate rows — Additional occurrences",
            "Memory usage (MB)",
        ],
        "value": [
            f"{len(df):,}",
            f"{len(df.columns):,}",
            f"{df.duplicated().sum():,}",
            f"{df.memory_usage(deep=True).sum() / 1024**2:.2f}",
        ],
    })

    summary_tables = [
        style_overview(
            summary,
            f"{name} — Raw data summary",
        ).to_html()
    ]

    # check the optional identifier column
    if key is not None:
        missing_key = (
            df[key]
            .astype("string")
            .str.strip()
            .fillna("")
            .eq("")
        )

        key_checks = pd.DataFrame({
            "check": [
                "Missing or blank IDs",
                "Duplicate IDs — Additional occurrences",
                "Distinct non-missing IDs",
            ],
            "rows": [
                int(missing_key.sum()),
                int(df.loc[~missing_key, key].duplicated().sum()),
                int(df.loc[~missing_key, key].nunique()),
            ],
        })

        summary_tables.append(
            style_overview(
                key_checks,
                f"{name} — Key check: {key}",
                {"rows": "{:,.0f}"},
            ).to_html()
        )

    display(HTML(
        '<div style="display:flex; gap:32px; '
        'align-items:flex-start; flex-wrap:wrap;">'
        + "".join(
            f"<div>{table}</div>"
            for table in summary_tables
        )
        + "</div>"
    ))

    # inspect column types, missing values and distinct values
    column_profile = pd.DataFrame({
        "column": df.columns,
        "dtype": df.dtypes.astype(str).to_numpy(),
        "missing": df.isna().sum().to_numpy(),
        "missing_pct": (
            df.isna().mean().mul(100).to_numpy()
            if len(df)
            else [float("nan")] * len(df.columns)
        ),
        "unique_values": df.nunique(dropna=True).to_numpy(),
    })

    display(HTML(
        '<div style="overflow-x:auto; margin-top:20px;">'
        + style_overview(
            column_profile,
            f"{name} — Column overview",
            {
                "missing": "{:,.0f}",
                "missing_pct": "{:.2f}%",
                "unique_values": "{:,.0f}",
            },
        ).to_html()
        + "</div>"
    ))

    # visualize missing values when present
    missing_columns = (
        column_profile.loc[
            column_profile["missing"].gt(0),
            ["column", "missing_pct"],
        ]
        .sort_values("missing_pct", ascending=False)
    )

    if not missing_columns.empty:
        fig, ax = plt.subplots(
            figsize=(10, max(3, len(missing_columns) * 0.4))
        )

        bars = ax.barh(
            missing_columns["column"],
            missing_columns["missing_pct"],
            color=COLORS["blue"],
        )

        ax.invert_yaxis()

        ax.bar_label(
            bars,
            labels=[
                f"{value:.2f}%"
                for value in missing_columns["missing_pct"]
            ],
            padding=5,
            color=COLORS["text"],
        )

        ax.set_title(f"{name} — Missing values", pad=16)
        ax.set_xlabel("Missing values (%)")
        ax.set_ylabel("")
        ax.set_xlim(0, 115)
        ax.set_axisbelow(True)
        ax.grid(axis="y", visible=False)

        fig.tight_layout()
        plt.show()

    else:
        display(HTML(
            '<p style="color:'
            + COLORS["ice"]
            + '; font-weight:bold;">'
            "No missing values found."
            "</p>"
        ))

    # preview the original values without changing their formatting
    for label, preview in [
        ("First rows", df.head(preview_rows)),
        ("Last rows", df.tail(preview_rows)),
    ]:
        display(HTML(
            '<div style="overflow-x:auto; margin-top:20px;">'
            + style_overview(
                preview,
                f"{name} — {label}",
            ).to_html()
            + "</div>"
        ))

    # return the profile for optional further inspection
    return column_profile