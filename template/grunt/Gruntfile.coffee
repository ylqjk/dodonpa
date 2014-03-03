module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    watch:
      gruntfile:
        files: ['Gruntfile.coffee']
      coffee:
        files: ['src/**/*.coffee']
        tasks: ['coffee:dist']
      jade:
        files: ['src/**/*.jade']
        tasks: ['jade:dist']
      options:
        livereload: true
    connect:
      server:
        options:
          port: 9001
          base: '.tmp'
    clean:
      dist: 'dist'
      server: '.tmp'
    copy:
      dist:
        files: do ->
          return [] unless grunt.file.isFile('bower.json')
          mainFiles = grunt.file.readJSON('bower.json').main
          mainFiles = [mainFiles] unless Array.isArray(mainFiles)
          mainFiles.map (filepath) ->
            dirpath = /^[^\/]*\//.exec(filepath)[0]
            expand: true,
            cwd: '.tmp'
            dest: dirpath.slice(0, -1)
            src: filepath.slice(dirpath.length)
    coffeelint:
      options:
        max_line_length:
          level: 'ignore'
      dist:
        src: [
          'src/**/*.coffee'
          'test/**/*.coffee'
          '*.coffee'
        ]
    coffee:
      options:
        bare: true
      dist:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: '.tmp'
        ext: '.js'
    jade:
      options:
        client: false
        pretty: true
      dist:
        expand: true
        cwd: 'src'
        src: ['**/*.jade']
        dest: '.tmp'
        ext: '.html'
    karma:
      unit:
        configFile: 'karmafile.coffee'
      watch:
        configFile: 'karmafile.coffee'
        autoWatch: true
        singleRun: false

  grunt.loadNpmTasks task for task of grunt.config.data.pkg.devDependencies when /^grunt-/.test(task)

  defaultTasks = [
    'clean:dist'
    'coffeelint:dist'
    'build'
  ]

  grunt.registerTask 'build', [
    'clean:server'
    'coffee:dist'
    'jade:dist'
  ]

  grunt.registerTask 'serve', [
    'build'
    'connect'
    'watch'
  ]

  if grunt.file.isDir('test')
    grunt.registerTask 'test', [
      'build'
      'karma:watch'
    ]
    defaultTasks.push('karma:unit')

  if grunt.file.isFile('bower.json')
    defaultTasks.push('copy:dist')

  grunt.registerTask 'default', defaultTasks
  return
