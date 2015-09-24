{CompositeDisposable} = require 'atom'
protagonist = require 'protagonist'

module.exports = ProtagonistAtom =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'protagonist-atom:parse': => @parse()

  deactivate: ->
    @subscriptions.dispose()

  # serialize: ->

  parse: ->
    workspace = atom.workspace
    editor = workspace.getActiveTextEditor()
    blueprintSource = editor.getText()

    # Parse the actual buffer
    protagonist.parse blueprintSource, (err, result) ->

      # Open new editor for the output
      workspace.open(null, {
        activatePane: true,
        split: 'right'
        }).then (editor) ->

          serializedRefract = JSON.stringify(result, null, 2)
          editor.setText(serializedRefract)
          editor.setGrammar(atom.grammars.grammarForScopeName('source.json'))
