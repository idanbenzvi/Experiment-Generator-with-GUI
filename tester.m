% try
% a = TrialFrame
% s = Stimulus
% s.parentTrialFrame = a;
% catch
%     disp('ERROR');
% clear('all')
% 
% [windowPtr,rect]=Screen('OpenOffscreenWindow',1);
% %[windowPtr,rect]=Screen('OpenOffscreenWindow',2 [,color] [,rect] [,pixelSize] [,specialFlags] [,multiSample]);
% end
% 
data_with_init_time = [ 
       1, 10, 5, 3 ;
       3, 10, 3, 9 ;
       7, 10, 4, 8 ;
       12,10, 2, 2 ];

h = barh(data_with_init_time, 'stack');
set(h(1), 'facecolor', 'none', 'EdgeColor', 'none'); % disable the color of the first column (init time)
set(gca, 'YTickLabel', {'proc 1', 'proc 2', 'proc 3', 'proc 4'} ); % change the y axis tick to your name of the process
axis ij; % Put the first row at top
% function tester
%     clc
%     DlgH = figure();
%     TreePosition = [5 5 300 300];
% 
%     % <1x1 com.mathworks.hg.peer.UITreePeer>
%     M_treeH = com.mathworks.hg.peer.UITreePeer;
%     M_treeH.setRoot([]);  %[JS] Remove default JTree->colors/sports/food
% 
%     %<1x1 javahandle_withcallbacks.com.mathworks.hg.peer.UITreePeer>
%     TreeH = javacomponent(M_treeH, TreePosition, DlgH);
%     set(TreeH, ...
%         'Visible',                  1, ...  %[JS] 0 or 1
%         'MultipleSelectionEnabled', 0, ...
%         'NodeWillExpandCallback',   {@nodeWillExpandFcn, DlgH}, ...
%         'NodeExpandedCallback',     {@nodeExpandedFcn,   DlgH}, ...
%         'NodeSelectedCallback',     {@nodeSelectedFcn,   DlgH});
% 
%     %set some nodes and add them to the root node
%     myRoot = uitreenode('v0', 0, 'Cars', '1', false);
%     Node10 = uitreenode('v0', 10, 'Audi', [], true);
%     Node20 = uitreenode('v0', 20, 'Ferrari', [], false);
%     Node30 = uitreenode('v0', 30, 'Mercedes', [], false);
%     myRoot.add(Node10);
%     myRoot.add(Node20);
%     myRoot.add(Node30);
% 
%     
%     %set the tree and expand myRoot node
%     TreeH.setRoot(myRoot);
%     TreeH.expand(myRoot);
%         newnode = uitreenode('v0',11,'a1',[],false);
% 
%     Node30.add(newnode);
% end
% 
% function nodeWillExpandFcn(TreeH, EventData, DlgH)
% 
%     EventNodeH = EventData.getCurrentNode;
%     if TreeH.isLoaded(EventNodeH)
%         NodeUD = get(EventNodeH, 'UserData');
%     end
% 
%     % Simulates a dynamic number (between 1 and 5) of ferrari owners.
%     % Each owner has a random name of 10 letters.
%     % Data from owners could be retreived from database in this callback.
%     % For small number of childnodes a simple way of updating info is to
%     % remove all children and add them all again. Maybe not efficient but
%     % it works.
%     if EventData.getCurrentNode.getValue == 20
%         EventNodeH.removeAllChildren;
%         nNodes = 1 + round(4*rand);
%         for i=1:nNodes
%             Value = 20 + i;
%             Name = char(round(97 + 25*rand(1,10))); %random name
%             NodeTmp = uitreenode('v0', Value, Name, [], true);
%             EventNodeH.add(NodeTmp);
%         end
%     end
%     TreeH.reloadNode(EventNodeH); %was the way I found to draw changes
% end
% 
% function nodeSelectedFcn(TreeH, EventData, DlgH)
%     disp('wow');
%     EventNodeH = EventData.getCurrentNode;
% %     if TreeH.isLoaded(EventNodeH)
%     NodeUD = get(EventNodeH, 'Name')
%     disp(NodeUD);
% %     end
% end
% 
% function nodeExpandedFcn(TreeH, EventData, DlgH)
% 
% end