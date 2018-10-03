{
   [big_fury]
   888888888     8888   888888888888   8888       888888888      8888      8888     888888888   
 8888888888888   8888   888888888888   8888     8888888888888    8888      8888   8888888888888
 8888     8888                88888            8888       8888   8888      8888   8888     8888 
 888888888       8888       888888     8888   8888         8888  8888      8888   888888888     
   8888888888    8888      88888       8888   8888         8888  8888      8888     88888888888 
        888888   8888    88888         8888   8888         8888  8888      8888           888888
 8888      8888  8888   88888          8888    8888       8888   8888      8888   8888      8888
 8888888888888   8888  88888888888888  8888     8888888888888     888888888888    8888888888888 
   8888888888    8888  88888888888888  8888       888888888        8888888888       8888888888  

  Unit� SearchInListBox
  =====================

  Description : Unit� permettant des recherches � partir d'une cha�ne sur une ListBox. A peu pr�s
                toutes les recherches que j'avais besoin. Si ca peut servir � quelqu'un...

  Proc�dures  : - Cherche_ListBox           : Permet de chercher dans une ListBox une cha�ne. Elle recherche non pas la
                                              cha�ne exacte, mais le d�but. Exemple : Si vous voulez rechercher 'Casino'
                                              et que dans la ListBox � un Item il y a 'Casino Cool!', la fonction va
                                              renvoyer son ItemIndex (Le texte 'Casino Cool!' sera pris en compte).
                                              Renvoie sinon -1 dans les cas non trouv�.

                - MotClef_ListBox           : Permet de faire des recherches par Mot Clef. Pour cela, sp�cifiez une ListBox qui
                                              servira d'endroit de stockage pour les mots clefs. Ensuite, sp�cifiez la cha�ne �
                                              chercher. Exemple : Mot � rechercher : 'Casino.com'. Contenu de la ListBox :
                                              'Casino, Cool, Cas, Casin'. Renverra l'ItemIndex 0 (le premier) car Casino est un mot
                                              clef. Renvoi sinon -1 si pas trouv�.

                - GetKeyWord_ListBox        : Compl�ment de MotClef_ListBox. Permet d'avoir le mot clef qui a �t� reconnu dans la chaine (� partir
                                              de son Index).

                - ChercheExact_ListBox      : Compl�ment de Cherche_ListBox. Permet de rechercher une cha�ne avec un item EXACT de la ListBox (sauf
                                              la casse).

                - DC_Cherche_ListBox        : Version de DelphiCool (http://delphicool.developpez.com) de Cherche_ListBox. Avec moi elle buggait, alors...
                                              
  Auteur      : [big_fury]SiZiOUS

  E-mail      : sizious@yahoo.fr

  URL         : http://www.sbibuilder.fr.st

  Remarques   : NBSousChaine prise sur Phidels.com, Merci � Michel. [http://www.phidels.com]
                Remerciement tout de m�me � la fonction de DelphiCool m�me si elle me convient pas :)
   
}

unit sh_listb;

interface

uses
   StdCtrls, SysUtils, Classes; //Classe : pour celle de DelphiCool

//function Cherche_ListBox(Chaine : string ; ListBox : TListBox) : Integer;
//function MotClef_ListBox(ChaineATraiter : string ; ListBoxDeMotsClefs : TListBox) : Integer;
//function GetKeyWord_ListBox(ListBoxItemIndex : integer ; ListBoxDeMotsClefs : TListBox) : string;
function ChercheExact_ListBox(Chaine : string ; ListBox : TListBox) : integer;
//function NbSousChaine(substr: string; s: string): integer;
//function DC_Cherche_ListBox(Chaine : string ; ListBox : TListBox) : integer;

implementation

{------------------------------< FUNCTION Cherche_ListBox >------------------------------------------------------------------ }

{ function Cherche_ListBox(Chaine : string ; ListBox : TListBox) : Integer;
var
  Index : integer;
  CurrentItem : string;

begin
  Result := -1;
  Chaine := UpperCase(Chaine);

  for Index := 0 to ListBox.Items.Count - 1 do
  begin
    CurrentItem := UpperCase(ListBox.Items.Strings[Index]);
    //AddError(IntToStr(Index)  + ' WinText : ' + Chaine + ' Nb Sous Chaine : ' + IntToStr(NbSousChaine(Chaine, CurrentItem)));
    //AddError(Chaine + ' - ' + CurrentItem);
    if NbSousChaine(Chaine, CurrentItem) > 0 then
    begin
      Result := Index;
      Exit;
    end;
  end;
end;

{------------------------------< FUNCTION MotClef_ListBox >------------------------------------------------------------------ }

{function MotClef_ListBox(ChaineATraiter : string ; ListBoxDeMotsClefs : TListBox) : Integer;
var
  Index : integer;
  CurrentItem : string;

begin
  Result := -1;
  ChaineATraiter := UpperCase(ChaineATraiter);
  
  for Index := 0 to ListBoxDeMotsClefs.Items.Count - 1 do
  begin
    CurrentItem := UpperCase(ListBoxDeMotsClefs.Items.Strings[Index]);
    //AddError(IntToStr(Index)  + ' WinText : ' + Chaine + ' Nb Sous Chaine : ' + IntToStr(NbSousChaine(Chaine, CurrentItem)));
    //AddError(Chaine + ' - ' + CurrentItem);
    if NbSousChaine(CurrentItem, ChaineATraiter) > 0 then
    begin
      Result := Index;
      Exit;
    end;
  end;
end;

{------------------------------< FUNCTION GetKeyWord_ListBox >------------------------------------------------------------------ }

{ function GetKeyWord_ListBox(ListBoxItemIndex : integer ; ListBoxDeMotsClefs : TListBox) : string;
begin
  Result := '';
  if (ListBoxDeMotsClefs.Items.Count = 0) or (ListBoxItemIndex > ListBoxDeMotsClefs.Items.Count - 1) then Exit;
  Result := ListBoxDeMotsClefs.Items.Strings[ListBoxItemIndex];
end;

{------------------------------< FUNCTION ChercheExact_ListBox >------------------------------------------------------------------ }

function ChercheExact_ListBox(Chaine : string ; ListBox : TListBox) : integer;
var
  Index : integer;
  CurrentItem : string;
  
begin
  Result := -1;
  Chaine := UpperCase(Chaine);

  for Index := 0 to ListBox.Items.Count - 1 do
  begin
    CurrentItem := UpperCase(ListBox.Items.Strings[Index]);
    //AddError(IntToStr(Index)  + ' WinText : ' + Chaine + ' Nb Sous Chaine : ' + IntToStr(NbSousChaine(Chaine, CurrentItem)));
    //AddError(Chaine + ' - ' + CurrentItem);
    if CurrentItem = Chaine then
    begin
      Result := Index;
      Exit;
    end;
  end;
end;

{------------------------------< FUNCTION NBSousChaine >------------------------------------------------------------------ }
{ renvoie le nombre de fois que la sous chaine substr est pr�sente dans la chaine S}
{ Michel, http://www.phidels.com/ }
{ function NbSousChaine(substr: string; s: string): integer;

function Droite(substr: string; s: string): string;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

begin
  result:=0;
  while pos(substr,s)<>0 do
  begin
    S:=droite(substr,s);
    inc(result);
  end;
end;

//VERSION DELPHICOOL
{^^^^^^^^ Recherche dans une ListBox ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^}

{ function DC_Cherche_ListBox(Chaine : string ; ListBox : TListBox) : integer;
var
  TayChain, ListCont, i, j : integer;
  s, s2                    : string;
  ListVirtuel              : TStringList;

begin
      ListVirtuel := TStringList.Create;        //on creer une liste virtuelle
      TayChain    := Length(Chaine);            //taille de la chainne � chercher
      ListCont    := ListBox.Count-1;           //nb d'items -1

    For i:= 0 to ListCont do
     begin
      s := ListBox.Items.Strings[i]; // on recup la ligne
       s2 := '';
       if Length(s) > TayChain Then    // si la taille de l'item est la meme que celle de la chaine on ne fait rien
        begin
          for j := 1 to TayChain do    // sinon on le met � la meme taille
           begin
             s2 := s2 + s[j]; // On met cette ligne � la meme taille que la recherche
           end;
        end
        else s2 := s;

      ListVirtuel.Add(s2); //on ajoute les items ds la liste virtuelle
     end;

      result := ListVirtuel.IndexOf(Chaine); // le r�sultat en integer

      ListVirtuel.Destroy;

end;  }

end.

