from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(args: list[str]) -> str:
    pass


@result_handler(no_ui=True)
def handle_result(args: list[str], answer: str, target_window_id: int, boss: Boss) -> None:
    tm = boss.active_tab_manager_with_dispatch
    if tm is not None:
        tab_num = int(args[1])
        if tab_num > len(tm.tabs):
            boss.new_tab()
        elif tab_num == tm.active_tab_idx + 1:
            boss.goto_tab(0)
        else:
            boss.goto_tab(tab_num)
