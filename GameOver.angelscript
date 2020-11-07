#include "Button.angelscript"

vector2 TamanhoTelaGameOver = GetScreenSize();
						
float MetadeTelaGameOverX = (TamanhoTelaGameOver.x / 2) - 256;
float MetadeTelaGameOverY = (TamanhoTelaGameOver.y / 2) - 32;

// Inicia a Instância do Botao, mas ainda não joga na tela
Button VoltarJogo("entities/start-game.png", vector2(256, MetadeTelaGameOverY + 250));

	vector2 TamanhoTela2 = GetScreenSize();
						
	float MetadeTelaX = (TamanhoTela2.x / 2) - 256;
	float MetadeTelaY = (TamanhoTela2.y / 2) + 100;

void StartGameOver()
	{
	LoadMusic("soundfx/game_over.mp3");
	PlaySample("soundfx/game_over.mp3");
	LoopSample("soundfx/game_over.mp3", true);	
	
	vector2 PosicaoBotaoVoltar = GetScreenSize();
	VoltarJogo.setPos(PosicaoBotaoVoltar / 2.0f);
	}
	
void UpdateGameOver()
	{				
	DrawText(vector2(MetadeTelaX + 180, MetadeTelaY), "Score: " + Pontos, "Verdana60.fnt", CorBrancoFull);
	DrawSprite("entities/game-over.png", vector2(256, MetadeTelaY - 100), 0xFFFFFFFF);
	VoltarJogo.putButton();
	
	ETHInput@ input = GetInputHandle();
	
	if(input.KeyDown(K_ESC))
		{
		Exit();
		}
	if(VoltarJogo.isPressed())
		{
		StopSample("soundfx/menu.mp3");
		Vida = 100;
		Pontos = 0;
		LoadScene("scenes/Menu.esc", "StartMenu", "UpdateMenu");
		VoltarJogo.setPressed(false);
		}

	}