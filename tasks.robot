*** Settings ***
Documentation       Template robot main suite.
Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Excel.Files
Library             RPA.Excel.Application
Resource            config.robot
*** Variables ***
# URL que será utilizada para fazer login
${URL}              http://helpdesk.fesfsus.ba.gov.br/index.php?noAUTO=1
# Browser que será realizado os testes
${browser}          Chrome
# Identificador do campo de login de usuário
${textbox_login}    id:login_name
# Identificador do campo de senha de usuário
${textbox_senha}            xpath://body/div[1]/div[1]/div[1]/div[2]/div[1]/form[1]/div[1]/div[1]/div[3]/input[1]
# Login de usuário que fará login no GLPI
${login}            ${GLPI_LOGIN}
# Senha de usuário que fará login no GLPI
${senha}            ${GLPI_SENHA}
# Identificador do Botão para entrar no GLPI
${button}                   xpath://button[contains(text(),'Entrar')]
# Identificador do Login de usuário que será criado no GLPI
${nome_user}                xpath://input[@id='name']
# Identificador do Nome de usuário que será criado no GLPI
${nome_do_user}             xpath://input[@name='firstname']
# Identificador do Sobrenome de usuário que será criado no GLPI
${sobrenome_do_user}        xpath://input[@name='realname']
# Identificador da Senha de usuário que será criado no GLPI
${senha_user}               xpath://input[@id='password']
# Identificador da Senha de usuário que será criado no GLPI
${c_senha_user}             xpath://input[@id='password2']
# Identificador do email de usuário que será criado no GLPI
${email_user}               xpath://input[@name='_useremails[-1]']
# Login de usuário que será criado no GLPI
${nome}             user.teste.
# Nome de usuário que será criado no GLPI
${nome_completo}    User Teste 
# Senha de usuário que será criado no GLPI
${senha_padrao}     teste123@
*** Tasks ***
Abrir o Navegador e Criar o Usuário Real
    Abrir o GLPI
    Fazer Login
    Ir para a guia de Criação de Usuário
    Utilizar Dados Reais para cada pessoa do Excel

*** Keywords ***
Abrir o GLPI
    # Comando para abrir o navegador
    Open Browser             ${URL}                     ${browser}
    # Comando para maximizar a janela
    Maximize Browser Window
Fazer Login
    # Comando para inserir texto
    Input Text               ${textbox_login}           ${login}
    # Comando para inserir texto em formato de senha
    Input Password           ${textbox_senha}           ${senha}
    # Comando para clicar no botão
    Click Button             ${button}
Ir para a guia de Criação de Usuário
    # Comando para ir para um novo endereço
    Go To    http://helpdesk.fesfsus.ba.gov.br/front/user.form.php
    # Comando para esperar por tempo determinado
    Sleep    2s
Digitar Dados Reais
    [Arguments]    ${Pessoa}
    Wait Until Element Is Visible    ${nome_user}
    Input Text        ${nome_user}            ${Pessoa}[USUARIO]
    Input Text        ${nome_do_user}         ${Pessoa}[NOME]
    Input Text        ${sobrenome_do_user}    ${Pessoa}[SOBRENOME]
    Input Password    ${senha_user}           trocar123
    Input Password    ${c_senha_user}         trocar123
    Input Text        ${email_user}           ${Pessoa}[E-MAIL]
    # Click Element     xpath://[@input='E-mail padrão']
    # Execute Javascript    document.getElementById('select2-dropdown_usertitles_id1645063675-container').click()
    # Click Element           xpath://tbody/tr[15]/td[2]/div[1]/span[1]
    Click Element                    xpath://tbody/tr[18]/td[4]/div[1]/span[1]/span[1]/span[1]
    Wait Until Element Is Visible    xpath://body/span[1]/span[1]/span[2]/ul[1]/li[4]
    Click Element                    xpath://body/span[1]/span[1]/span[2]/ul[1]/li[4]
    Wait Until Element Is Visible    xpath://body/div[2]/div[1]/div[1]/main[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/form[1]/div[1]/div[4]/button[1]
    #Click Button     xpath://body/div[2]/div[1]/div[1]/main[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/form[1]/div[1]/div[4]/button[1]
    Sleep    10s
Utilizar Dados Reais para cada pessoa do Excel
    RPA.Excel.Application.Open Workbook    escada.xlsx
    ${Pessoas}    Read Worksheet As Table    header=True
    Close Workbook

    FOR    ${Pessoa}    IN    @{Pessoas}
        Digitar Dados Reais    ${Pessoa}
        Wait Until Element Is Visible    xpath://body/div[@id='messages_after_redirect']/div[1]/div[1]/button[1]
        Click Element                    xpath://body/div[@id='messages_after_redirect']/div[1]/div[1]/button[1]
    END